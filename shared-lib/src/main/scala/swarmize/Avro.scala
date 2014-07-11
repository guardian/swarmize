package swarmize

import java.io.{ByteArrayInputStream, ByteArrayOutputStream, InputStream}

import org.apache.avro.file.{CodecFactory, DataFileStream, DataFileWriter}
import org.apache.avro.generic.{GenericDatumReader, GenericDatumWriter, GenericRecord}

import scala.collection.convert.decorateAll._

object Avro {
  def toBytes(doc: GenericRecord): Array[Byte] = {
    val writer = new GenericDatumWriter[GenericRecord](doc.getSchema)

    val byteArrayOutput = new ByteArrayOutputStream()
    val dataFileWriter = new DataFileWriter[GenericRecord](writer)

    dataFileWriter.setCodec(CodecFactory.snappyCodec())
    dataFileWriter.create(doc.getSchema, byteArrayOutput)
    dataFileWriter.append(doc)
    dataFileWriter.close()

    byteArrayOutput.toByteArray
  }

  def fromBytes(bytes: Array[Byte]): List[GenericRecord] = fromStream(new ByteArrayInputStream(bytes))

  def fromStream(i: InputStream): List[GenericRecord] = {
    val datumReader = new GenericDatumReader[GenericRecord]()
    val reader = new DataFileStream[GenericRecord](i, datumReader)
    reader.iterator.asScala.toList
  }

}
