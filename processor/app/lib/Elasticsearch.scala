package lib

import com.amazonaws.services.ec2.model.{Filter, DescribeInstancesRequest}
import org.elasticsearch.client.transport.TransportClient
import org.elasticsearch.common.settings.ImmutableSettings
import org.elasticsearch.common.transport.InetSocketTransportAddress
import play.api.Logger
import swarmize.aws.AWS

import scala.util.Random

object Elasticsearch {

  lazy val discoveredElasticsearchHost = {
    import scala.collection.JavaConversions._
    val possibleHosts = AWS.EC2.describeInstances(
      new DescribeInstancesRequest().withFilters(
        new Filter("tag:Name", List("swarmize-elasticsearch"))
      ))
    Random.shuffle(possibleHosts.getReservations.flatMap(_.getInstances)).headOption.map(_.getPublicDnsName)
  }

  private lazy val settings = ImmutableSettings.settingsBuilder()
    .put("cluster.name", "swarmize")
    .build()

  lazy val client = {
    val host = discoveredElasticsearchHost getOrElse sys.error("Cannot find elasticsearch")
    Logger.info("Connecting to elasticsearch cluster at " + host)
    new TransportClient(settings)
      .addTransportAddress(new InetSocketTransportAddress(host, 9300))
  }


}
