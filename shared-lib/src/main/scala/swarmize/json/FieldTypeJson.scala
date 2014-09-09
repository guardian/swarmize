package swarmize.json

import play.api.libs.json.Json

case class FieldTypeJson
(
  display_name: String,
  derived_fields: Option[List[String]]
)


object FieldTypeJson {
  implicit val reader = Json.format[FieldTypeJson]
}
