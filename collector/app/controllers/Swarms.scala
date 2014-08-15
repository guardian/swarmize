package controllers

import com.amazonaws.services.simpleworkflow.model.StartWorkflowExecutionRequest
import org.joda.time.DateTime
import org.joda.time.format.ISODateTimeFormat
import play.api.Logger
import play.api.libs.json._
import play.api.mvc._
import swarmize.Swarm
import swarmize.aws.{AWS, SimpleWorkflow}
import swarmize.json.SubmittedData

import scala.util.control.NonFatal

object Swarms extends Controller {

  def show(token: String) = Action {
    val config = Swarm.findByToken(token)

    config.map { c =>
      val msg =
        s"""
          |Swarm name: ${c.name}
          |Swarm description: ${c.description}
          |Schema:
          |${c.definition.toJson}
        """.stripMargin

      Ok(msg)
    } getOrElse {
      NotFound(s"Unknown token: $token")
    }
  }


  private def formFieldsToJson(fields: Map[String, Seq[String]]): JsValue = {
    val jsonValues = fields.mapValues {
      _.toList match {
        case Nil => JsNull
        case single :: Nil => JsString(single)
        case other => JsArray(other map JsString)
      }
    }

    JsObject(jsonValues.toSeq)
  }

  def submit(token: String) = Action { request =>
    Swarm.findByToken(token).map { config =>
      val json = request.body.asJson orElse request.body.asFormUrlEncoded.map(formFieldsToJson)

      json.map(doSubmitJson(config, _)) getOrElse
        BadRequest("Either submit text/json, application/json or application/x-www-form-urlencoded")

    } getOrElse {
      NotFound(s"Unknown swarm token: $token")
    }
 }

  def submitJson(token: String) = Action(parse.tolerantJson) { request =>
    Swarm.findByToken(token).map { swarm =>
      doSubmitJson(swarm, request.body)
    } getOrElse {
      NotFound(s"Unknown swarm token: $token")
    }
  }

  private def addTimestampIfNotPresent(json: JsObject): JsObject = {
    if (json.keys contains "timestamp") json
    else json ++ Json.obj("timestamp" -> DateTime.now.toString(ISODateTimeFormat.dateTime()))
  }

  def validateFields(jsObject: JsObject, swarm: Swarm): Unit = {
    // check all mandatory fields are there
    val mandatoryFields = swarm.fields.filter(_.isCompulsory).map(_.codeName)

    val missingFields = mandatoryFields.toSet -- jsObject.keys.toSet

    if (missingFields.nonEmpty)
      sys.error(s"The following mandatory fields are missing: ${missingFields.mkString(", ")}")

  }

  private def doSubmitJson(swarm: Swarm, data: JsValue): Result = try {
    val dataObj = addTimestampIfNotPresent(data.as[JsObject])

    // TODO: need to figure out here how to come up with the list of activities

    validateFields(dataObj, swarm)

    val fullObject = SubmittedData.wrap(dataObj, swarm, List("StoreInElasticsearch"))

    val msg = s"submission to ${swarm.name}:\n${Json.prettyPrint(fullObject.toJson)}\n"

    AWS.swf.startWorkflowExecution(
      new StartWorkflowExecutionRequest()
        .withDomain(SimpleWorkflow.domain)
        .withInput(Json.toJson(fullObject).toString())
        .withWorkflowId(fullObject.submissionId)
        .withWorkflowType(SimpleWorkflow.workflowType)
        .withTagList(fullObject.swarmToken)
    )

    Logger.info(msg)
    Ok(msg)

  } catch {
    case NonFatal(e) =>
      Logger.warn("submission failed", e)
      BadRequest(e.toString + "\n")
  }

}
