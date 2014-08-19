package lib

import com.amazonaws.services.simpleworkflow.flow.common.WorkflowExecutionUtils
import com.amazonaws.services.simpleworkflow.model._
import swarmize.ClassLogger
import swarmize.aws._
import swarmize.aws.swf.{SwfHistoryEvent, ActivityTaskCompleted, WorkflowExecutionStarted, SwfAsyncHelpers}

import scala.collection.convert.wrapAll._
import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.Future

object Decider extends ClassLogger {

  val swf = AWS.swf

  def run() {
    runAsync().onComplete(_ => run())
  }


  def makeDecision(decisionTask: DecisionTask): Decision = {
    val events = decisionTask.getEvents.map(SwfHistoryEvent.parse)

    // ignore the events that tell us the decider has been invoked
    val nonDecisionEvents = events.filterNot(_.isDecisionEvent)

    val lastInterestingEvent = nonDecisionEvents.last

    log.info(s"lastEvent was $lastInterestingEvent")

    val decision = lastInterestingEvent match {
      case e: WorkflowExecutionStarted =>
        new Decision()
          .withDecisionType(DecisionType.ScheduleActivityTask)
          .withScheduleActivityTaskDecisionAttributes(
            new ScheduleActivityTaskDecisionAttributes()
              .withActivityType(StoreInElasticsearchActivity.activityType)
              .withActivityId("blah")
              .withInput(e.input)
              .withTaskList(SimpleWorkflowConfig.defaultTaskList)
          )

      case e: ActivityTaskCompleted =>
        new Decision()
          .withDecisionType(DecisionType.CompleteWorkflowExecution)
          .withCompleteWorkflowExecutionDecisionAttributes(
            new CompleteWorkflowExecutionDecisionAttributes()
              .withResult(e.result)
          )

      case other =>
        log.info(s"don't know how to respond to a ${other.eventType} yet")
        new Decision()
          .withDecisionType(DecisionType.FailWorkflowExecution)
          .withFailWorkflowExecutionDecisionAttributes(
            new FailWorkflowExecutionDecisionAttributes()
              .withReason("decider can't respond to event type of " + other.eventType)
          )
    }

    log.info(s"decision = ${WorkflowExecutionUtils.prettyPrintDecision(decision)}" )

    decision
  }


  def runAsync(): Future[Unit] = {
    import SwfAsyncHelpers._

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
