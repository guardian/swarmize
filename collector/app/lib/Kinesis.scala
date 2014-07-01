package lib

import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

import org.apache.avro.file.{CodecFactory, DataFileWriter}
import org.apache.avro.generic.{GenericDatumWriter, GenericRecord}
import play.api.Logger
import scala.collection.convert.wrapAll._

object Kinesis {
  lazy val streamName = {
    val name = AWS.kinesis.listStreams().getStreamNames.toList.find(_.startsWith("Swarmize")).get
    Logger.info("Using kinesis stream: " + name)
    name
  }

  def submit(swarmToken: String, doc: GenericRecord) {
    val writer = new GenericDatumWriter[GenericRecord](doc.getSchema)

    val byteArrayOutput = new ByteArrayOutputStream()
    val dataFileWriter = new DataFileWriter[GenericRecord](writer)

    dataFileWriter.setCodec(CodecFactory.snappyCodec())
    dataFileWriter.create(doc.getSchema, byteArrayOutput)
    dataFileWriter.append(doc)
    dataFileWriter.close()

    AWS.kinesis.putRecord(streamName, ByteBuffer.wrap(byteArrayOutput.toByteArray), swarmToken)
  }
}
