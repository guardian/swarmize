package lib

import com.amazonaws.services.simpleworkflow.model.{RespondActivityTaskFailedRequest, RespondActivityTaskCompletedRequest, TaskList, PollForActivityTaskRequest}
import com.amazonaws.util.Base64
import play.api.libs.json.Json
import swarmize.ClassLogger
import swarmize.aws.{SimpleWorkflow, AWS}

import scala.annotation.tailrec
import scala.util.control.NonFatal

class ActivityDispatcher extends ClassLogger with Runnable {

  @tailrec
  final def run() {
    runOnce()
    run()
  }

  def runOnce() {
    log.info("polling...")

    val activityTask = AWS.swf.pollForActivityTask(
      new PollForActivityTaskRequest()
        .withDomain(SimpleWorkflow.domain)
        .withIdentity(SimpleWorkflow.serverIdentity)
        .withTaskList(SimpleWorkflow.defaultTaskList)
    )

    if (Option(activityTask.getTaskToken).isDefined) {
      log.info(s"now should run ${activityTask.getActivityType} with input:\n${activityTask.getInput}")

      try {
        val json = Json.parse(activityTask.getInput)

        val activity = Activity.lookupByType(activityTask.getActivityType)

        val result = activity.process(json)

        AWS.swf.respondActivityTaskCompleted(
          new RespondActivityTaskCompletedRequest()
            .withResult(result.toString)
            .withTaskToken(activityTask.getTaskToken)
        )
      } catch {
        case NonFatal(e) =>
          AWS.swf.respondActivityTaskFailed(
            new RespondActivityTaskFailedRequest()
              .withTaskToken(activityTask.getTaskToken)
              .withReason("Exception thrown: " + e.getMessage)
              .withDetails(e.toString)
          )

      }

    }
  }
}
