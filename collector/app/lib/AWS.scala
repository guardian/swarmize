package lib

import com.amazonaws.regions.{Regions, Region}
import com.amazonaws.services.kinesis.AmazonKinesisClient

object AWS {
  lazy val region = Region getRegion Regions.US_EAST_1

  lazy val kinesis = region.createClient(classOf[AmazonKinesisClient], null, null)

}
