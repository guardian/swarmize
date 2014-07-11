package swarmize

import com.swarmize.Metadata
import org.apache.avro.{SchemaBuilder, Schema}
import org.apache.avro.generic.{GenericRecordBuilder, GenericRecord}

import scala.collection.convert.wrapAll._


case class SwarmConfig
(
  token: String,
  submissionSchema: Schema
) {
  def name = submissionSchema.getDoc

  lazy val metadata =
    Metadata.newBuilder()
      .setName(name)
      .setToken(token)
      .setSteps(List("geocode", "es_store"))
      .build()

  lazy val bundleSchema = SchemaBuilder.builder()
    .record("Submission").namespace("com.swarmize")
    .fields()
      .name("data").`type`(submissionSchema).noDefault()
      .name("metadata").`type`(Metadata.getClassSchema).noDefault()
    .endRecord

  def makeBundle(submittedData: GenericRecord): GenericRecord =
    new GenericRecordBuilder(bundleSchema)
      .set("data", submittedData)
      .set("metadata", metadata)
      .build()
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
