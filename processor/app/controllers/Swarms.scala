package controllers

import com.amazonaws.services.dynamodbv2.model.ConditionalCheckFailedException
import play.api.libs.json.{JsArray, JsResultException, JsString, Json}
import play.api.mvc._
import swarmize.json.SwarmDefinition
import swarmize.{SwarmTable, UniqueId}

object Swarms extends Controller {

  def returnAll() = Action {
    val allKeys = SwarmTable.readAllTokens()

    val urls = allKeys.map(t => routes.Swarms.get(t).url).map(JsString)
    Ok(JsArray(urls))
  }

  def addNew() = add(UniqueId.generateSwarmToken)

  def get(token: String) = Action { request =>
    val defn = SwarmTable.get(token)

    defn.map(c => Ok(Json.toJson(c.definition))) getOrElse NotFound(s"No swarm with token $token found")
  }

  def add(token: String) = Action(parse.tolerantJson) { request =>
    try {
      val defn = request.body.as[SwarmDefinition]

      SwarmTable.write(token, Json.stringify(request.body))

      Created(token)
    } catch {
      case e: JsResultException =>
        BadRequest(s"Bad json supplied: $e")

      case e: ConditionalCheckFailedException =>
        BadRequest(s"Already got a swarm with token $token")
    }
  }
}
