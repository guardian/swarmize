package lib

import org.apache.avro.generic.GenericRecord
import play.api.libs.json.JsValue
import swarmize.ClassLogger

object StoreInElasticsearchActivity extends Activity with ClassLogger {
  val name = "StoreInElasticsearch"
  val version = "1"

  override def process(r: JsValue): JsValue = {
    log.info("Should now insert into elasticsearch: " + r)

    val theData = r \ "data"
    val metaData = r \ "metadata"

    log.info(s"types are: data = ${theData.getClass} meta = ${metaData.getClass}")

    log.info(s"the es object = ${theData.toString}")

    Elasticsearch.client.prepareIndex("voting", "data")
      .setSource(theData.toString)
      .get()


    log.info("inserted")

    r
  }

}
