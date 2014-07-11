package lib

import com.amazonaws.regions.{Regions, Region}
import com.amazonaws.services.kinesis.AmazonKinesisClient
import com.amazonaws.services.simpleworkflow.AmazonSimpleWorkflowClient

object AWS {
  lazy val region = Region getRegion Regions.US_EAST_1

  lazy val kinesis = region.createClient(classOf[AmazonKinesisClient], null, null)

  lazy val swf = region.createClient(classOf[AmazonSimpleWorkflowClient], null, null)

}
