package swarmize.aws

import java.util.UUID

import com.amazonaws.services.simpleworkflow.model._
import com.amazonaws.util.{AwsHostNameUtils, EC2MetadataUtils, Base64}
import org.apache.avro.generic.GenericRecord
import org.joda.time.Duration

import play.api.Logger
import play.api.libs.json.{Json, JsValue}
import swarmize.json.SubmittedData
import swarmize.ClassLogger

import scala.collection.convert.wrapAll._

object SimpleWorkflow extends ClassLogger {

  val domain = "swarmize"

  val workflowType = new WorkflowType().withName("swarm").withVersion("2")

  val defaultTaskList = new TaskList().withName("main")

  val oneHourInSeconds = Duration.standardHours(1).getStandardSeconds
  val twelveHoursInSeconds = Duration.standardHours(12).getStandardSeconds
  val tenMinutesInSeconds = Duration.standardMinutes(10).getStandardSeconds

  lazy val serverIdentity = Option(EC2MetadataUtils.getInstanceId) getOrElse AwsHostNameUtils.localHostName


  def registerWorkflowType(workflowType: WorkflowType) {
    AWS.swf.registerWorkflowType(
      new RegisterWorkflowTypeRequest()
        .withDefaultTaskList(defaultTaskList)
        .withDomain(domain)
        .withName(workflowType.getName)
        .withVersion(workflowType.getVersion)
        .withDefaultChildPolicy(ChildPolicy.ABANDON)
        .withDefaultExecutionStartToCloseTimeout(twelveHoursInSeconds.toString)
        .withDefaultTaskStartToCloseTimeout(tenMinutesInSeconds.toString)
    )
  }

  def listWorkflowTypes(): List[WorkflowTypeInfo] = {
    AWS.swf.listWorkflowTypes(
      new ListWorkflowTypesRequest()
        .withDomain(domain)
        .withRegistrationStatus(RegistrationStatus.REGISTERED)
    ).getTypeInfos.toList
  }

  def createWorkflowIfNeeded(workflowType: WorkflowType) {
    val workflow = listWorkflowTypes().find(_.getWorkflowType == workflowType)

    workflow map { w =>
      log.info(s"Workflow already exists: $w")
    } getOrElse {
      logAround(s"Creating workflow $workflowType") {
        registerWorkflowType(workflowType)
      }
    }
  }



  def listActivityTypes(): List[ActivityTypeInfo] = {
    AWS.swf.listActivityTypes(
      new ListActivityTypesRequest()
      .withDomain(domain)
      .withRegistrationStatus(RegistrationStatus.REGISTERED)
    ).getTypeInfos.toList
  }

  def registerActivityType(activityType: ActivityType) {
    AWS.swf.registerActivityType(
      new RegisterActivityTypeRequest()
        .withDomain(domain)
        .withDefaultTaskList(defaultTaskList)
        .withName(activityType.getName)
        .withVersion(activityType.getVersion)
        .withDefaultTaskScheduleToCloseTimeout(oneHourInSeconds.toString)
        .withDefaultTaskScheduleToStartTimeout(tenMinutesInSeconds.toString)
        .withDefaultTaskStartToCloseTimeout(tenMinutesInSeconds.toString)
        .withDefaultTaskHeartbeatTimeout(tenMinutesInSeconds.toString)
    )
  }

  def createActivityIfNeeded(activityType: ActivityType) {
    val activity = listActivityTypes().find(_.getActivityType == activityType)

    activity map { a =>
      log.info(s"Activity already exists: $a")
    } getOrElse {
      log.info(s"Creating activity $activityType")
      registerActivityType(activityType)
    }
  }

  def registerWorkflow() {
    createWorkflowIfNeeded(workflowType)
  }

}
