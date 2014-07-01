package lib

import com.amazonaws.auth.DefaultAWSCredentialsProviderChain
import com.amazonaws.services.kinesis.clientlibrary.lib.worker.{Worker, InitialPositionInStream, KinesisClientLibConfiguration}
import com.amazonaws.services.kinesis.metrics.impl.NullMetricsFactory
import com.amazonaws.util.{AwsHostNameUtils, EC2MetadataUtils}

import scala.concurrent.ExecutionContext.Implicits.global

import scala.concurrent.Future

object KinesisWorker {
  lazy val workerId = Option(EC2MetadataUtils.getInstanceId).getOrElse(AwsHostNameUtils.localHostName)

  lazy val config = new KinesisClientLibConfiguration(
      "stasher-listener",
      Kinesis.streamName,
      new DefaultAWSCredentialsProviderChain(),
      workerId
    )
    .withMaxRecords(100)
    .withInitialPositionInStream(InitialPositionInStream.TRIM_HORIZON)

  lazy val worker = new Worker(RecordProcessor, config, new NullMetricsFactory)

  def start() {
    Future {
      worker.run()
    }
  }

}
