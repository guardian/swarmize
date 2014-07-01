package lib

import play.api.Logger

import scala.collection.convert.wrapAll._

object Kinesis {
  lazy val streamName = {
    val name = AWS.kinesis.listStreams().getStreamNames.toList.find(_.startsWith("Swarmize")).get
    Logger.info("Using kinesis stream: " + name)
    name
  }
}
