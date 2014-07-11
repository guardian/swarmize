package lib

import com.amazonaws.auth.profile.ProfileCredentialsProvider
import com.amazonaws.auth._
import com.amazonaws.regions.{Regions, Region}
import com.amazonaws.services.kinesis.AmazonKinesisClient
import com.amazonaws.services.simpleworkflow.AmazonSimpleWorkflowClient

object AWS {
  lazy val region = Region getRegion Regions.EU_WEST_1

  lazy val credentialProvider = new AWSCredentialsProviderChain(
    new EnvironmentVariableCredentialsProvider,
    new SystemPropertiesCredentialsProvider,
    new ProfileCredentialsProvider("profile swarmize"),
    new InstanceProfileCredentialsProvider
  )

  lazy val kinesis = region.createClient(classOf[AmazonKinesisClient], credentialProvider, null)

  lazy val swf = region.createClient(classOf[AmazonSimpleWorkflowClient], credentialProvider, null)

}
