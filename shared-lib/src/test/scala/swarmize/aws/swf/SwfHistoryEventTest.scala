package swarmize.aws.swf

import com.amazonaws.services.simpleworkflow.model.{HistoryEvent, WorkflowExecutionStartedEventAttributes}
import org.joda.time.DateTime
import org.scalatest._

class SwfHistoryEventTest extends FlatSpec with Matchers with OptionValues {
  "SwfHistoryEvent" should "be able to represent a WorkflowExecutionStarted event" in {
    val executionStarted = new HistoryEvent()
      .withEventType("WorkflowExecutionStarted")
      .withEventId(1L)
      .withEventTimestamp(new DateTime(1972, 7, 20, 11, 0).toDate)
      .withWorkflowExecutionStartedEventAttributes(
        new WorkflowExecutionStartedEventAttributes()
          .withInput("hello")
      )

    val ev = SwfHistoryEvent.parse(executionStarted)

    ev.getClass shouldBe classOf[WorkflowExecutionStarted]
  }

}
