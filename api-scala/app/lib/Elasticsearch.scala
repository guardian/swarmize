package lib

import com.amazonaws.services.ec2.model.{DescribeInstancesRequest, Filter}
import org.elasticsearch.action.{ActionListener, ListenableActionFuture}
import org.elasticsearch.client.transport.TransportClient
import org.elasticsearch.common.settings.ImmutableSettings
import org.elasticsearch.common.transport.InetSocketTransportAddress
import play.api.Logger
import swarmize.aws.AWS

import scala.concurrent.{Future, Promise}
object Elasticsearch {

  lazy val discoveredElasticsearchHosts = {
    import scala.collection.JavaConversions._
    val possibleHosts = AWS.EC2.describeInstances(
      new DescribeInstancesRequest().withFilters(
        new Filter("tag:Name", List("swarmize-elasticsearch"))
      ))
    possibleHosts.getReservations.flatMap(_.getInstances).map(_.getPublicDnsName)
  }

  private lazy val settings = ImmutableSettings.settingsBuilder()
    .put("cluster.name", "swarmize")
    .build()

  lazy val client = {
    val hosts = discoveredElasticsearchHosts map (new InetSocketTransportAddress(_, 9300))

    if (hosts.isEmpty) {
      sys.error("could not find the elasticsearch hosts")
    }

    Logger.info("Connecting to elasticsearch cluster at " + discoveredElasticsearchHosts)
    new TransportClient(settings)
      .addTransportAddresses(hosts: _*)
  }


}




object ElasticsearchPromise {
  def apply[A](esResult: ListenableActionFuture[A]): Promise[A] = {
    val promise = Promise[A]()
    esResult.addListener(new ActionListener[A] {
      def onFailure(e: Throwable) { promise.failure(e) }
      def onResponse(response: A) { promise.success(response) }
    })
    promise
  }

  implicit class ListenableActionFuturePimps[A](f: ListenableActionFuture[A]) {
    def future: Future[A] = apply(f).future
  }
}
