package swarmize

import org.apache.avro.Schema
import swarmize.aws.AWS
import swarmize.aws.dynamodb.DynamoDBTable

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
      println("read: " + definition)
      SwarmConfig(token, null)
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
  submissionSchema: Schema
) {
  def name = submissionSchema.getDoc
  def definition = submissionSchema.toString(true)
}

// This is just a placeholder for something that will probably be a real service
object SwarmConfig {

  def findByToken(token: String): Option[SwarmConfig] = {
    val parser = new Schema.Parser

    Option(getClass.getResourceAsStream(s"/swarms/$token.avsc"))
      .map(parser.parse)
      .map(SwarmConfig(token, _))
  }

}
