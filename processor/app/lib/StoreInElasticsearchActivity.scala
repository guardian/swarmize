package lib

import org.elasticsearch.common.settings.ImmutableSettings
import play.api.libs.json.{JsObject, JsValue, Json}
import swarmize._
import swarmize.json.SubmittedData

import scala.concurrent.Future

object  StoreInElasticsearchActivity extends Activity with ClassLogger {
  val name = "StoreInElasticsearch"
  val version = "1"

  override def process(r: SubmittedData): Future[SubmittedData] = {
    log.info("Should now insert into elasticsearch: " + r)

    val theData = Json.stringify(r.data)

    val indexName = r.swarmStatus match {
      case Swarm.Draft => s"${r.swarmToken}_draft"
      case Swarm.Open => r.swarmToken
      case Swarm.Closed => sys.error("received a actvity for a closed swarm: this should not be possible!")
    }

    log.info(s"swarmToken: ${r.swarmToken} the es object = $theData")

    ensureIndexExistsFor(r, indexName)

    Elasticsearch.client.prepareIndex(indexName, "data", r.submissionId)
      .setSource(theData)
      .get()

    log.info("inserted")

    // todo: we should be calling elasticsearch async here too
    Future.successful(r)
  }


  def mappingForFieldType(field: SwarmField): JsValue = field match {
    case _ : FreeTextField =>
      Json.obj("type" -> "string", "index" -> "analyzed")

    case _ : TokenField =>
      Json.obj("type" -> "string", "index" -> "not_analyzed")

    case _ : NumberField =>
      Json.obj("type" -> "long")

    case _ : BooleanField =>
      Json.obj("type" -> "boolean")

    case _ : GeoPointField =>
      Json.obj("type" -> "geo_point")
  }

  def mappingFor(fields: List[SwarmField]): JsValue = {
    val fieldMappings: List[(String, JsValue)] = fields.map { f =>
      f.codeName -> mappingForFieldType(f)
    } :+ (
      "timestamp" -> Json.obj("type" -> "date")
    )

    Json.obj(
      "properties" -> JsObject(fieldMappings)
    )
  }

  def ensureIndexExistsFor(r: SubmittedData, indexName: String) = {
    val exists = Elasticsearch.client.admin.indices
      .prepareExists(indexName)
      .get()
      .isExists

    if (!exists) {

      val swarm = Swarm.findByToken(r.swarmToken).get

      val indexSettings = ImmutableSettings.settingsBuilder()
        .put("index.number_of_shards", "3")
        .put("index.auto_expand_replicas", "0-1")

      logAround(s"Index $indexName does not exist, creating") {
        val mapping = mappingFor(swarm.fields)

        log.info("mapping is " + mapping)

        Elasticsearch.client.admin.indices.prepareCreate(indexName)
          .setCause(s"Received submission ${r.submissionId}")
          .setSettings(indexSettings)
          .addMapping("data", mappingFor(swarm.fields ::: swarm.derivedFields).toString())
          .get()
      }
    }
  }
}
