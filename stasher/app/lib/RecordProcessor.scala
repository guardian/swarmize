package lib

import com.amazonaws.services.kinesis.clientlibrary.interfaces.{IRecordProcessorFactory, IRecordProcessorCheckpointer, IRecordProcessor}
import com.amazonaws.services.kinesis.clientlibrary.types.ShutdownReason
import com.amazonaws.services.kinesis.model.Record
import org.apache.avro.file.DataFileStream
import org.apache.avro.generic.{GenericRecord, GenericDatumReader}
import org.apache.avro.util.ByteBufferInputStream
import org.elasticsearch.action.index.IndexRequestBuilder
import play.api.Logger

class RecordProcessor extends IRecordProcessor {
  val datumReader = new GenericDatumReader[GenericRecord]()

  override def initialize(name: String) {
    Logger.info(s"Record processor starting: $name")
  }

  override def shutdown(checkpointer: IRecordProcessorCheckpointer, reason: ShutdownReason) {
    Logger.info(s"Record processor stopping: $reason")
  }

  override def processRecords(records: java.util.List[Record], checkpoint: IRecordProcessorCheckpointer) {
    import scala.collection.convert.wrapAll._

    Logger.info(s"Got ${records.size} records")

    val bulkInsertRequest = Elasticsearch.client.prepareBulk()

    for ((record, idx) <- records.zipWithIndex) {
      val bufStream = new ByteBufferInputStream(List(record.getData))
      val reader = new DataFileStream[GenericRecord](bufStream, datumReader)
      val obj = reader.iterator.toList.head
      val swarm = record.getPartitionKey

      Logger.info(s"$idx: ${record.getPartitionKey} $obj")

      bulkInsertRequest.add(
        new IndexRequestBuilder(Elasticsearch.client, swarm)
          .setSource(obj.toString)
          .setType("data")
      )

    }

    Logger.info(s"Inserting ${bulkInsertRequest.numberOfActions()}...")
    val resp = bulkInsertRequest.get()

    if (resp.hasFailures) {
      Logger.warn(s"failed: ${resp.buildFailureMessage}")
    } else {
      Logger.info(s"Inserted")
    }

    checkpoint.checkpoint()
  }
}

object RecordProcessor extends IRecordProcessorFactory{
  override def createProcessor() = new RecordProcessor
}
