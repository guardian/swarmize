package lib

import java.util.UUID

import com.amazonaws.services.simpleworkflow.model._
import com.amazonaws.util.Base64
import org.apache.avro.generic.GenericRecord
import org.joda.time.Duration
import play.api.Logger

import scala.collection.convert.wrapAll._

object SimpleWorkflow {
  val domain = "swarmize"

  val workflowType = new WorkflowType().withName("swarm").withVersion("2")

  val acivities = List("geocode", "es_store")

  val taskList = new TaskList().withName("main")

  val oneHourInSeconds = Duration.standardHours(1).getStandardSeconds
  val twelveHoursInSeconds = Duration.standardHours(12).getStandardSeconds
  val tenMinutesInSeconds = Duration.standardMinutes(10).getStandardSeconds

  def registerWorkflowType(workflowType: WorkflowType) {
    AWS.swf.registerWorkflowType(
      new RegisterWorkflowTypeRequest()
        .withDefaultTaskList(taskList)
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
      Logger.info(s"Workflow already exists: $w")
    } getOrElse {
      Logger.info(s"Creating workflow $workflowType")
      registerWorkflowType(workflowType)
    }
  }



  def listActivityTypes(): List[ActivityTypeInfo] = {
    AWS.swf.listActivityTypes(
      new ListActivityTypesRequest()
      .withDomain(domain)
      .withRegistrationStatus(RegistrationStatus.REGISTERED)
    ).getTypeInfos.toList
  }

  def registerActivityType(name: String, version: String) {
    AWS.swf.registerActivityType(
      new RegisterActivityTypeRequest()
        .withDomain(domain)
        .withDefaultTaskList(taskList)
        .withName(name)
        .withVersion(version)
        .withDefaultTaskScheduleToCloseTimeout(oneHourInSeconds.toString)
        .withDefaultTaskScheduleToStartTimeout(tenMinutesInSeconds.toString)
        .withDefaultTaskStartToCloseTimeout(tenMinutesInSeconds.toString)
    )
  }

  def createActivityIfNeeded(name: String, version: String) {
    val activityType = new ActivityType().withName(name).withVersion(version)
    val activity = listActivityTypes().find(_.getActivityType == activityType)

    activity map { a =>
      Logger.info(s"Activity already exists: $a")
    } getOrElse {
      Logger.info(s"Creating activity $activityType")
      registerActivityType(name, version)
    }
  }

  def createConfigStuff() = {
    createWorkflowIfNeeded(workflowType)
    acivities foreach (createActivityIfNeeded(_, "1"))
  }

  createConfigStuff()

  def submit(bundle: GenericRecord) {
    val bytes = Avro.toBytes(bundle)
    AWS.swf.startWorkflowExecution(
      new StartWorkflowExecutionRequest()
        .withDomain(domain)
        .withInput(Base64.encodeAsString(bytes: _*))
        .withWorkflowId(UUID.randomUUID().toString)
        .withWorkflowType(workflowType)
    )
  }
}
