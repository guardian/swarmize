package controllers

import play.api.Logger
import play.api.mvc._
import swarmize.SwarmConfig
import swarmize.aws.SimpleWorkflow
import swarmize.json.SubmittedData

import scala.util.control.NonFatal

object Swarm extends Controller {

  def show(token: String) = Action {
    val config = SwarmConfig.findByToken(token)

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

  def submit(token: String) = Action(parse.tolerantJson) { request =>
    val config = SwarmConfig.findByToken(token)
    val json = request.body

    config.map { c =>
      try {

        // TODO: need to figure out here how to come up with the list of activities

        // TODO: validate against swam config

        val fullObject = SubmittedData.wrap(json, c, List("StoreInElasticsearch"))

        val msg = s"submission to ${c.name}:\n$fullObject\n"

        SimpleWorkflow.submit(fullObject)
        Logger.info(msg)
        Ok(msg)
      } catch {
        case NonFatal(e) =>
          Logger.warn("submission failed", e)
          BadRequest(e.toString + "\n")
      }
    } getOrElse {
      NotFound(s"Unknown token: $token")
    }
  }

}
