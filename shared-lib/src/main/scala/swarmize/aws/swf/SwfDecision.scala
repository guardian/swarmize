package swarmize.aws.swf

import com.amazonaws.services.simpleworkflow.model._
import swarmize.aws.SimpleWorkflowConfig

object SwfDecision {
  def failWorkflowExecution(reason: String) =
    new Decision()
      .withDecisionType(DecisionType.FailWorkflowExecution)
      .withFailWorkflowExecutionDecisionAttributes(
        new FailWorkflowExecutionDecisionAttributes()
          .withReason(reason)
      )


  def completeWorkflowExecution(result: String) =
    new Decision()
      .withDecisionType(DecisionType.CompleteWorkflowExecution)
      .withCompleteWorkflowExecutionDecisionAttributes(
        new CompleteWorkflowExecutionDecisionAttributes()
          .withResult(result)
      )


  def scheduleActivityTask(activityType: ActivityType, activityId: String, input: String) =
    new Decision()
      .withDecisionType(DecisionType.ScheduleActivityTask)
      .withScheduleActivityTaskDecisionAttributes(
        new ScheduleActivityTaskDecisionAttributes()
          .withActivityType(activityType)
          .withActivityId(activityId)
          .withInput(input)
          .withTaskList(SimpleWorkflowConfig.defaultTaskList)
      )

}
