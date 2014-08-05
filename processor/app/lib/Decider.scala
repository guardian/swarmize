package lib

import com.amazonaws.services.simpleworkflow.flow.common.WorkflowExecutionUtils
import com.amazonaws.services.simpleworkflow.model._
import com.amazonaws.util.{AwsHostNameUtils, EC2MetadataUtils}
import swarmize.ClassLogger
import swarmize.aws._

import scala.annotation.tailrec
import scala.collection.convert.wrapAll._

class Decider extends ClassLogger with Runnable {

  val swf = AWS.swf

  @tailrec
  final def run() {
    runOnce()
    run()
  }

  def runOnce() {
    log.info("polling...")

    val decisionTask = swf.pollForDecisionTask(
      new PollForDecisionTaskRequest()
        .withDomain(SimpleWorkflow.domain)
        .withIdentity(SimpleWorkflow.serverIdentity)
        .withTaskList(SimpleWorkflow.defaultTaskList)
    )

    if (Option(decisionTask.getTaskToken).isDefined) {

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
                .withTaskList(SimpleWorkflow.defaultTaskList)
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

      swf.respondDecisionTaskCompleted(
        new RespondDecisionTaskCompletedRequest()
          .withTaskToken(decisionTask.getTaskToken)
          .withDecisions(decision)
      )

    }
  }



}
