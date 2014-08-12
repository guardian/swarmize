package controllers

import play.api.Logger
import play.api.libs.json._
import play.api.mvc._
import swarmize.Swarm
import swarmize.aws.SimpleWorkflow
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



  def submitForm(token: String) = Action(parse.tolerantFormUrlEncoded) { request =>

    Swarm.findByToken(token).map { config =>
      val jsonValues = request.body.mapValues {
        _.toList match {
          case Nil => JsNull
          case single :: Nil => JsString(single)
          case other => JsArray(other map JsString)
        }
      }

      doSubmitJson(config, JsObject(jsonValues.toSeq))

    } getOrElse {
      NotFound(s"Unknown token: $token")
    }
 }



  def submitJson(token: String) = Action(parse.tolerantJson) { request =>

    Swarm.findByToken(token).map { swarm =>
      doSubmitJson(swarm, request.body)
    } getOrElse {
      NotFound(s"Unknown token: $token")
    }
  }


  def doSubmitJson(swarm: Swarm, data: JsValue): Result = try {
    // TODO: need to figure out here how to come up with the list of activities

    // TODO: validate against swam config

    val fullObject = SubmittedData.wrap(data, swarm, List("StoreInElasticsearch"))

    val msg = s"submission to ${swarm.name}:\n$fullObject\n"

    SimpleWorkflow.submit(fullObject)
    Logger.info(msg)
    Ok(msg)

  } catch {
    case NonFatal(e) =>
      Logger.warn("submission failed", e)
      BadRequest(e.toString + "\n")
  }

}
