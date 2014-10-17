package swarmize

import com.amazonaws.services.dynamodbv2.document.spec.ScanSpec
import play.api.libs.json.Json
import swarmize.aws.AWS
import swarmize.json.SwarmDefinition

import scala.collection.convert.wrapAll._

object SwarmTable {
  private val table = AWS.dynamodb.getTable("swarms")

  def get(token: String): Option[Swarm] = {
    for {
      r <- Option(table.getItem("token", token))
      definition <- Option(r.getString("definition"))
    } yield {
      val defn = Json.parse(definition).as[SwarmDefinition]
      Swarm(token, defn)
    }

  }

  def readAllTokens(): List[String] = {
    table.scan(new ScanSpec().withAttributesToGet("token"))
      .map(_.getString("token"))
      .toList
  }
}
