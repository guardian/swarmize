package lib

import org.apache.avro.generic.GenericRecord
import play.api.libs.json.JsValue
import swarmize.ClassLogger
import swarmize.json.SubmittedData

object StoreInElasticsearchActivity extends Activity with ClassLogger {
  val name = "StoreInElasticsearch"
  val version = "1"

  override def process(r: SubmittedData): SubmittedData = {
    log.info("Should now insert into elasticsearch: " + r)

    val theData = r.data

    log.info(s"swarmToken: ${r.swarmToken} the es object = ${theData.toString}")

    Elasticsearch.client.prepareIndex(r.swarmToken, "data", r.submissionId)
      .setSource(theData.toString)
      .get()


    log.info("inserted")

    r
  }

}
