package lib

import org.apache.avro.generic.GenericRecord
import swarmize.ClassLogger

object StoreInElasticsearchActivity extends Activity with ClassLogger {
  val name = "StoreInElasticsearch"
  val version = "1"

  override def process(r: GenericRecord): GenericRecord = {
    log.info("Should now insert into elasticsearch: " + r)

    val theData = r.get("data")
    val metaData = r.get("metadata")

    log.info(s"types are: data = ${theData.getClass} meta = ${metaData.getClass}")

    log.info(s"the es object = ${theData.toString}")

    Elasticsearch.client.prepareIndex("voting", "data")
      .setSource(theData.toString)
      .get()


    log.info("inserted")

    r
  }

}
