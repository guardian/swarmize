package swarmize

import java.util.concurrent.TimeUnit

import com.google.common.cache.{CacheLoader, CacheBuilder}
import swarmize.Swarm._


case class Swarm
(
  token: String,
  definition: json.SwarmDefinition
) {

  def name = definition.name
  def description = definition.description

  lazy val fields: List[SwarmField] = definition.fields.map(SwarmField.apply)

  lazy val derivedFields: List[SwarmField] = fields.flatMap(_.derivedFields)

  def status: Status =
    if (definition.closes_at.exists(_.isBeforeNow)) Closed
    else if (definition.opens_at.exists(_.isBeforeNow)) Open
    else Draft

  def isClosed = status == Closed

}




object Swarm {
  sealed trait Status
  case object Draft extends Status
  case object Open extends Status
  case object Closed extends Status

  private object loader extends CacheLoader[String, Option[Swarm]] {
    override def load(token: String): Option[Swarm] = SwarmTable.get(token)
  }

  private val cache = CacheBuilder.newBuilder()
    .expireAfterWrite(5, TimeUnit.SECONDS)
    .build[String, Option[Swarm]](loader)

  def findByToken(token: String): Option[Swarm] = cache.get(token)

}



