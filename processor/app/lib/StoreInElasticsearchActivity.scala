package lib

import org.elasticsearch.common.settings.ImmutableSettings
import play.api.libs.json.{JsNull, JsObject, JsValue, Json}
import swarmize.json.SubmittedData
import swarmize.{SwarmField, ClassLogger, Swarm}

object StoreInElasticsearchActivity extends Activity with ClassLogger {
  val name = "StoreInElasticsearch"
  val version = "1"

  override def process(r: SubmittedData): SubmittedData = {
    log.info("Should now insert into elasticsearch: " + r)

    val theData = Json.stringify(r.data)


    log.info(s"swarmToken: ${r.swarmToken} the es object = $theData")

    ensureIndexExistsFor(r)

    Elasticsearch.client.prepareIndex(r.swarmToken, "data", r.submissionId)
      .setSource(theData)
      .get()

    log.info("inserted")

    r
  }


  def mappingForFieldType(fieldType: String): JsValue = fieldType match {
    case "text" | "bigtext" | "address" | "city" | "county" | "state" | "country" =>
      Json.obj("type" -> "string", "index" -> "analyzed")

    case "postcode" | "email" | "pick_one" | "pick_several" =>
      Json.obj("type" -> "string", "index" -> "not_analyzed")

    case "number" | "rating" =>
      Json.obj("type" -> "long")

    case "yesno" | "check_box" =>
      Json.obj("type" -> "boolean")

    case other =>
      log.warn(s"Hmm. Didn't know how to map field type $other")
      JsNull
  }

  def mappingFor(fields: List[SwarmField]): JsValue = {
    val fieldMappings: List[(String, JsValue)] = fields.map { f =>
      f.codeName -> mappingForFieldType(f.fieldType)
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
