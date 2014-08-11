package swarmize

import play.api.libs.json.Json
import swarmize.aws.AWS
import swarmize.aws.dynamodb.DynamoDBTable
import swarmize.json.SwarmDefinition

object SwarmTable extends DynamoDBTable {
  val client = AWS.dynamodb
  val tableName = "swarms"

  def write(token: String, definition: String): Unit = {
   putWithoutOverwrite {
     Map(
      "token" -> S(token),
      "definition" -> S(definition)
     )
   }
  }

  def get(token: String): Option[SwarmConfig] = {
    for {
      r <- get(Map("token" -> S(token)))
      definition <- r.get("definition")
    } yield {
      val defn = Json.parse(definition.getS).as[SwarmDefinition]
      SwarmConfig(token, defn)
    }
  }

  def readAllTokens(): List[String] = {
    scan.toList.flatMap { r =>
      for {
        token <- r.get("token")
      } yield {
        token.getS
      }
    }
  }
}

case class SwarmConfig
(
  token: String,
  definition: SwarmDefinition
) {
  def name = definition.name
  def description = definition.description
}

object SwarmConfig {

  def findByToken(token: String): Option[SwarmConfig] = SwarmTable.get(token)

}
