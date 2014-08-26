package lib

import com.amazonaws.services.simpleworkflow.flow.common.WorkflowExecutionUtils
import com.amazonaws.services.simpleworkflow.model._
import swarmize.aws.swf._
import swarmize.aws.{AWS, SimpleWorkflowConfig}
import swarmize.json.SubmittedData
import swarmize.{ClassLogger, Swarm}

import scala.collection.convert.wrapAll._
import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.Future

object Decider extends ClassLogger {

  val swf = AWS.swf

  def run() {
    runAsync().onComplete(_ => run())
  }

  def scheduleNext(data: SubmittedData): Decision = {
    data.processingSteps match {
      case head :: rest =>
        SwfDecision.scheduleActivityTask(
          activityType = Activity.lookupByName(head).activityType,
          activityId = data.submissionId,
          input = data.copy(processingSteps = rest).toJson.toString())

      case Nil =>
        SwfDecision.completeWorkflowExecution(data.toJson.toString())
    }
  }

  def scheduleInitialActivity(submissionId: String, currentResult: String): Decision = {
    val submittedData = SubmittedData.fromJsonString(currentResult)

    val swarm = Swarm.findByToken(submittedData.swarmToken)
      .getOrElse(sys.error("Swarm no longer exists: " + submittedData.swarmToken))

    val requiredAcivities = Activity.allThatShouldProcess(swarm).map(_.name)

    log.info(s"$submissionId: required activities are $requiredAcivities")

    val newData = submittedData.copy(processingSteps = requiredAcivities)

    scheduleNext(newData)
  }

  def makeDecision(decisionTask: DecisionTask): Decision = {
    val submissionId = decisionTask.getWorkflowExecution.getWorkflowId

    val events = decisionTask.getEvents.toList.map(SwfHistoryEvent.parse)

    // ignore the events that tell us the decider has been invoked
    val nonDecisionEvents = events.filterNot(_.isDecisionEvent)

    val lastInterestingEvent = nonDecisionEvents.last

    log.info(s"$submissionId: lastEvent was ${lastInterestingEvent.eventType}")

    val decision = lastInterestingEvent match {
      case e: WorkflowExecutionStarted =>
        scheduleInitialActivity(submissionId, e.input)

      case e: ActivityTaskCompleted =>
        scheduleNext(SubmittedData.fromJsonString(e.result))

      case other =>
        log.info(s"don't know how to respond to a ${other.eventType} yet")

        SwfDecision.failWorkflowExecution(
          reason = s"decider can't respond to event type of ${other.eventType}"
        )
    }

    log.info(s"$submissionId: decision = ${WorkflowExecutionUtils.prettyPrintDecision(decision)}" )

    decision
  }


  def runAsync(): Future[Unit] = {
    import swarmize.aws.swf.SwfAsyncHelpers._

    log.info("polling...")

    val request = new PollForDecisionTaskRequest()
      .withDomain(SimpleWorkflowConfig.domain)
      .withIdentity(SimpleWorkflowConfig.serverIdentity)
      .withTaskList(SimpleWorkflowConfig.defaultTaskList)

    swf.pollForDecisionTaskFuture(request)
      // no action on decision tasks that are empty
      .filter(_.getTaskToken != null)
      .map { dt =>
        val decision = makeDecision(dt)

        swf.respondDecisionTaskCompleted(
          new RespondDecisionTaskCompletedRequest()
            .withTaskToken(dt.getTaskToken)
            .withDecisions(decision)
        )
      }
      .map(_ => Unit)
  }
}
