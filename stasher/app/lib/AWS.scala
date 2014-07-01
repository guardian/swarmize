package lib

import com.amazonaws.regions.{Regions, Region}
import com.amazonaws.services.ec2.AmazonEC2AsyncClient
import com.amazonaws.services.kinesis.AmazonKinesisClient

object AWS {
  lazy val region = Region.getRegion(Regions.US_EAST_1)

  lazy val kinesis = region.createClient(classOf[AmazonKinesisClient], null, null)

  lazy val EC2 = region.createClient(classOf[AmazonEC2AsyncClient], null, null)

}
