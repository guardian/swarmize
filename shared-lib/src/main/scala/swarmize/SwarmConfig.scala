package swarmize

import com.swarmize.Metadata
import org.apache.avro.{SchemaBuilder, Schema}
import org.apache.avro.generic.{GenericRecordBuilder, GenericRecord}
import play.api.libs.json.{JsValue, Json}

import scala.collection.convert.wrapAll._


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
