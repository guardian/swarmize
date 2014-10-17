package swarmize

import java.util.concurrent.TimeUnit

import com.google.common.cache.{CacheBuilder, CacheLoader}
import swarmize.aws.AWS

object SwarmApiKeys {

  private object SwarmApiKeyTable {
    private val table = AWS.dynamodb.getTable("api_keys")

    def swarmTokenForApiKey(apiKey: String): Option[String] = {
      for {
        row <- Option(table.getItem("api_key", apiKey))
        s <- Option(row.getString("swarm_token"))
      } yield s
    }
  }


  private object loader extends CacheLoader[String, Option[String]] {
    override def load(apiKey: String): Option[String] = {
      SwarmApiKeyTable.swarmTokenForApiKey(apiKey)
    }
  }

  private val cache = CacheBuilder.newBuilder()
    .expireAfterWrite(5, TimeUnit.SECONDS)
    .build[String, Option[String]](loader)


  def isValid(swarmToken: String, apiKey: String) =
    cache.get(apiKey).contains(swarmToken)

}
