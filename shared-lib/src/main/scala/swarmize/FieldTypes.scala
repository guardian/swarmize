package swarmize

import com.google.common.io.Resources
import play.api.libs.json.Json
import swarmize.json.FieldTypeJson

object FieldTypes {

  lazy val json = Json.parse(Resources.toByteArray(Resources.getResource("field_types.json")))


  lazy val types = json.as[Map[String, FieldTypeJson]]
}
