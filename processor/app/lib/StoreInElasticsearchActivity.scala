package lib

import org.elasticsearch.common.settings.ImmutableSettings
import play.api.libs.json.{JsNull, JsObject, JsValue, Json}
import swarmize.json.SubmittedData
import swarmize._

import scala.concurrent.Future

object StoreInElasticsearchActivity extends Activity with ClassLogger {
  val name = "StoreInElasticsearch"
  val version = "1"

  override def process(r: SubmittedData): Future[SubmittedData] = {
    log.info("Should now insert into elasticsearch: " + r)

    val theData = Json.stringify(r.data)


    log.info(s"swarmToken: ${r.swarmToken} the es object = $theData")

    ensureIndexExistsFor(r)

    Elasticsearch.client.prepareIndex(r.swarmToken, "data", r.submissionId)
      .setSource(theData)
      .get()

    log.info("inserted")

    // todo: we should be calling elasticsearch async here too
    Future.successful(r)
  }


  def mappingForFieldType(field: SwarmField): JsValue = field match {
    case _ : FreeTextField =>
      Json.obj("type" -> "string", "index" -> "analyzed")

    case _ : FixedTextField =>
      Json.obj("type" -> "string", "index" -> "not_analyzed")

    case _ : NumberField =>
      Json.obj("type" -> "long")

    case _ : BooleanField =>
      Json.obj("type" -> "boolean")
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

  def ensureIndexExistsFor(r: SubmittedData) = {
    val indexName = r.swarmToken

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
          .addMapping("data", mappingFor(swarm.fields).toString())
          .get()
      }
    }
  }

}
