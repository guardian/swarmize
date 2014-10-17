package swarmize

import java.util.concurrent.TimeUnit

import com.google.common.cache.{CacheBuilder, CacheLoader}
import swarmize.aws.AWS
import swarmize.aws.dynamodb.DynamoDBTable

object SwarmApiKeys {

  private object SwarmApiKeyTable extends DynamoDBTable {
    val client = AWS.dynamodb
    val tableName = "api_keys"

    def swarmTokenForApiKey(apiKey: String): Option[String] = {
      for {
        r <- get(Map("api_key" -> S(apiKey)))
        s <- r.get("swarm_token")
      } yield s.getS
    }
  }


  private object loader extends CacheLoader[String, Option[String]] {
    override def load(apiKey: String): Option[String] = {
      println("lookup: " + apiKey)
      SwarmApiKeyTable.swarmTokenForApiKey(apiKey)
    }
  }

  private val cache = CacheBuilder.newBuilder()
    .expireAfterWrite(5, TimeUnit.SECONDS)
    .build[String, Option[String]](loader)


  def isValid(swarmToken: String, apiKey: String) =
    cache.get(apiKey).contains(swarmToken)

}
