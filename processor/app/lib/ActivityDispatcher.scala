package lib

import com.amazonaws.services.simpleworkflow.model._
import play.api.libs.json.Json
import swarmize.ClassLogger
import swarmize.aws.{AWS, SimpleWorkflowConfig}
import swarmize.json.SubmittedData

import scala.concurrent.Future
import scala.util.control.NonFatal

import scala.concurrent.ExecutionContext.Implicits.global

object ActivityDispatcher extends ClassLogger with Runnable {

  def run() {
    runAsync() onComplete (_ => run())
  }

  def reportFailed(activityTask: ActivityTask, e: Throwable): Unit = {
    log.error(s"Activity ${activityTask.getActivityType} failed", e)

    AWS.swf.respondActivityTaskFailed(
      new RespondActivityTaskFailedRequest()
        .withTaskToken(activityTask.getTaskToken)
        .withReason("Exception thrown: " + e.getMessage)
        .withDetails(e.toString)
    )
  }

  def doActivity(activityTask: ActivityTask): Unit = {
    log.info(s"now should run ${activityTask.getActivityType} with input:\n${activityTask.getInput}")

    try {
      val json = Json.parse(activityTask.getInput)
      val submittedData = json.as[SubmittedData]

      val activity = Activity.lookupByType(activityTask.getActivityType)

      activity.process(submittedData)
        .map { result =>
          AWS.swf.respondActivityTaskCompleted(
            new RespondActivityTaskCompletedRequest()
              .withResult(result.toJson.toString())
              .withTaskToken(activityTask.getTaskToken)
          )
        }
        .onFailure {
          case NonFatal(e) => reportFailed(activityTask, e)
        }

    } catch {
      case NonFatal(e) => reportFailed(activityTask, e)
    }

  }

  def runAsync(): Future[Unit] = {
    import swarmize.aws.swf.SwfAsyncHelpers._

    log.info("polling...")

    val activityTaskFuture = AWS.swf.pollForActivityTaskFuture(
      new PollForActivityTaskRequest()
        .withDomain(SimpleWorkflowConfig.domain)
        .withIdentity(SimpleWorkflowConfig.serverIdentity)
        .withTaskList(SimpleWorkflowConfig.defaultTaskList)
    )

    // now do the stuff we want to do - but do this async without blocking the poll future
    activityTaskFuture
      .filter(_.getTaskToken != null)
      .foreach(doActivity)

    // return the future just after it's done polling to queue up the next poll
    activityTaskFuture.map(_ => Unit)
  }


}
