import java.io.File

import com.swarmize.Metadata
import org.apache.avro.file.DataFileWriter
import org.apache.avro.{SchemaBuilder, Schema}
import org.apache.avro.generic.{GenericDatumWriter, GenericRecordBuilder, GenericDatumReader, GenericRecord}
import org.apache.avro.io.DecoderFactory
import org.joda.time.DateTime
import swarmize.SwarmConfig

object Main extends App {

  private def buildAvroDocFromJson(json: String, schema: Schema): GenericRecord = {
    val reader = new GenericDatumReader[GenericRecord](schema)
    val jsonDecoder = DecoderFactory.get().jsonDecoder(schema, json)
    reader.read(null, jsonDecoder)
  }


  println("yo")

  val config = SwarmConfig.findByToken("voting").get

  import scala.collection.convert.wrapAll._


  // make a demo submission object
  val obj = buildAvroDocFromJson(
    """{"user_key":12345,"timestamp":56789,"intent":"green","feedback": "Mr King","postcode":"N1 9GU","ip":"10.0.0.1"}""",
    config.submissionSchema)

  obj.put("timestamp", DateTime.now().getMillis)


  val metaObj = Metadata.newBuilder()
    .setName(config.name)
    .setToken("voting")
    .setSteps(List("geocode", "es_store"))
    .build()

  println(metaObj)

  // now make a schema with the meta data and the data

  val bundle = SchemaBuilder.builder()
     .record("Submission").namespace("com.swarmize")
     .fields()
       .name("data").`type`(config.submissionSchema).noDefault()
       .name("metadata").`type`(Metadata.getClassSchema).noDefault()
     .endRecord


  println(bundle.toString(true))

  val rec = new GenericRecordBuilder(bundle)
    .set("data", obj)
    .set("metadata", metaObj)
    .build()

  println(rec)

  val writer = new GenericDatumWriter[GenericRecord](rec.getSchema)
  val x = new DataFileWriter[GenericRecord](writer)

  x.create(rec.getSchema, new File("test.avro"))
  x.append(rec)
  x.close()

}
