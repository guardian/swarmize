package swarmize

import org.apache.avro.Schema



case class SwarmConfig
(
  token: String,
  submissionSchema: Schema
) {
  def name = submissionSchema.getDoc
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
