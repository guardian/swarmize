package swarmize.aws.swf

import com.amazonaws.services.simpleworkflow.flow.common.WorkflowExecutionUtils
import com.amazonaws.services.simpleworkflow.model._


sealed trait SwfHistoryEvent {
  def rawEvent: HistoryEvent
  def eventType: String = rawEvent.getEventType

  def eventId  = rawEvent.getEventId
  def isDecisionEvent = eventType startsWith "Decision"

  override def toString = WorkflowExecutionUtils.prettyPrintHistoryEvent(rawEvent)
}

case class WorkflowExecutionStarted(rawEvent: HistoryEvent) extends SwfHistoryEvent {
  def props = rawEvent.getWorkflowExecutionStartedEventAttributes
  def input = props.getInput
}

case class ActivityTaskStarted(rawEvent: HistoryEvent) extends SwfHistoryEvent

case class ActivityTaskScheduled(rawEvent: HistoryEvent) extends SwfHistoryEvent {
  def props = rawEvent.getActivityTaskScheduledEventAttributes
  def activityType = props.getActivityType
  def control = props.getControl
}

case class ActivityTaskCompleted(rawEvent: HistoryEvent) extends SwfHistoryEvent {
  def props = rawEvent.getActivityTaskCompletedEventAttributes
  def result = props.getResult
  def scheduledEventId = props.getScheduledEventId
}

case class ActivityTaskFailed(rawEvent: HistoryEvent) extends SwfHistoryEvent {
  def props = rawEvent.getActivityTaskFailedEventAttributes
  def details = props.getDetails
  def reason = props.getReason
}

case class ActivityTaskTimedOut(rawEvent: HistoryEvent) extends SwfHistoryEvent {
  def props = rawEvent.getActivityTaskTimedOutEventAttributes
  def details = props.getDetails
}

case class UnparsedHistoryEvent(rawEvent: HistoryEvent) extends SwfHistoryEvent


/*
 <b>Allowed Values: </b>
 WorkflowExecutionStarted,
 WorkflowExecutionCancelRequested,
 WorkflowExecutionCompleted,
 CompleteWorkflowExecutionFailed,
 WorkflowExecutionFailed,
 FailWorkflowExecutionFailed,
 WorkflowExecutionTimedOut,
 WorkflowExecutionCanceled,
 CancelWorkflowExecutionFailed,
 WorkflowExecutionContinuedAsNew,
  ContinueAsNewWorkflowExecutionFailed,
   WorkflowExecutionTerminated,
    DecisionTaskScheduled,
    DecisionTaskStarted,
    DecisionTaskCompleted,
    DecisionTaskTimedOut,
    ActivityTaskScheduled,
    ScheduleActivityTaskFailed,
    ActivityTaskStarted,
    ActivityTaskFailed,
    ActivityTaskTimedOut,
    ActivityTaskCanceled,
ActivityTaskCancelRequested,
RequestCancelActivityTaskFailed,
WorkflowExecutionSignaled,
MarkerRecorded,
RecordMarkerFailed,
TimerStarted,
StartTimerFailed,
TimerFired,
TimerCanceled,
CancelTimerFailed,
StartChildWorkflowExecutionInitiated,
StartChildWorkflowExecutionFailed,
ChildWorkflowExecutionStarted,
ChildWorkflowExecutionCompleted,
ChildWorkflowExecutionFailed,
ChildWorkflowExecutionTimedOut,
ChildWorkflowExecutionCanceled,
ChildWorkflowExecutionTerminated,
SignalExternalWorkflowExecutionInitiated,
SignalExternalWorkflowExecutionFailed,
ExternalWorkflowExecutionSignaled,
RequestCancelExternalWorkflowExecutionInitiated,
RequestCancelExternalWorkflowExecutionFailed,
ExternalWorkflowExecutionCancelRequested

*
 */

object SwfHistoryEvent {
  val all = List(
    WorkflowExecutionStarted,
    ActivityTaskStarted,
    ActivityTaskCompleted,
    ActivityTaskFailed
  )

  val allWithName = all.map(c => c.toString -> c).toMap.withDefaultValue(UnparsedHistoryEvent)

  def parse(ev: HistoryEvent): SwfHistoryEvent = allWithName(ev.getEventType).apply(ev)
}