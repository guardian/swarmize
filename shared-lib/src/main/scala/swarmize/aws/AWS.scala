package swarmize.aws

import com.amazonaws.AmazonWebServiceClient
import com.amazonaws.auth._
import com.amazonaws.auth.profile.ProfileCredentialsProvider
import com.amazonaws.regions.{Region, Regions}
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBAsyncClient
import com.amazonaws.services.ec2.AmazonEC2Client
import com.amazonaws.services.kinesis.AmazonKinesisClient
import com.amazonaws.services.simpleworkflow.AmazonSimpleWorkflowClient

import scala.reflect.ClassTag

object AWS {
  lazy val region = Region getRegion Regions.EU_WEST_1

  lazy val credentialProvider = new AWSCredentialsProviderChain(
    new EnvironmentVariableCredentialsProvider,
    new SystemPropertiesCredentialsProvider,
    new ProfileCredentialsProvider("profile swarmize"),
    new InstanceProfileCredentialsProvider
  )

  def createClient[T <: AmazonWebServiceClient](implicit m: ClassTag[T]): T =
    region.createClient(m.runtimeClass.asInstanceOf[Class[_ <: AmazonWebServiceClient]], credentialProvider, null).asInstanceOf[T]

  lazy val kinesis = createClient[AmazonKinesisClient]

  lazy val swf = createClient[AmazonSimpleWorkflowClient]

  lazy val EC2 = createClient[AmazonEC2Client]

  //lazy val dynamodb = createClient[AmazonDynamoDBAsyncClient]

  lazy val dynamodb = {
    val c = new AmazonDynamoDBAsyncClient(credentialProvider)
    c.setEndpoint("http://localhost:8000")
    c
  }
}
