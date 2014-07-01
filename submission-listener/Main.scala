import java.util

import com.amazonaws.auth.DefaultAWSCredentialsProviderChain
import com.amazonaws.services.kinesis.clientlibrary.interfaces.{IRecordProcessorCheckpointer, IRecordProcessor, IRecordProcessorFactory}
import com.amazonaws.services.kinesis.clientlibrary.lib.worker.{Worker, InitialPositionInStream, KinesisClientLibConfiguration}
import com.amazonaws.services.kinesis.clientlibrary.types.ShutdownReason
import com.amazonaws.services.kinesis.metrics.impl.NullMetricsFactory
import com.amazonaws.services.kinesis.model.Record
import com.amazonaws.util.{AwsHostNameUtils, EC2MetadataUtils}
import org.apache.avro.file.DataFileStream
import org.apache.avro.generic.{GenericDatumReader, GenericRecord}
import org.apache.avro.specific.SpecificDatumReader
import org.apache.avro.util.ByteBufferInputStream

class RecordProcessor extends IRecordProcessor {
  val datumReader = new GenericDatumReader[GenericRecord]()

  override def initialize(name: String) {
    println("Record processor starting: " + name)
  }

  override def shutdown(p1: IRecordProcessorCheckpointer, p2: ShutdownReason) {
    println("Record processor stopping: " + p2)
  }

  override def processRecords(records: java.util.List[Record], checkpoint: IRecordProcessorCheckpointer) {
    import scala.collection.convert.wrapAll._

    println(s"Got ${records.size} records")

    for ( (record, idx) <- records.zipWithIndex) {
      val bufStream = new ByteBufferInputStream(List(record.getData))
      val reader = new DataFileStream[GenericRecord](bufStream, datumReader)
      val obj = reader.iterator.toList.head

      println(s"$idx: ${record.getPartitionKey} $obj")

    }
  }
}

object RecordProcessor extends IRecordProcessorFactory{
  override def createProcessor() = new RecordProcessor
}

object Main extends App {
  println("Hi")


  lazy val workerId = Option(EC2MetadataUtils.getInstanceId).getOrElse(AwsHostNameUtils.localHostName)

  lazy val config = new KinesisClientLibConfiguration(
      "submission-listener",
      "Swarmize-Collector-10DWPUK9PR8FJ-SubmissionStream-QN8H6DWB126I",
      new DefaultAWSCredentialsProviderChain(), workerId)
    .withMaxRecords(100)  // this effectively is the number of parallel gets that we will do
    .withInitialPositionInStream(InitialPositionInStream.TRIM_HORIZON)

  lazy val worker = new Worker(RecordProcessor, config, new NullMetricsFactory)
  worker.run()

}

