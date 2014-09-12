package swarmize.json

import play.api.libs.json.{JsObject, Json}

case class ProcessingStepJson
(
  endpoint: String,
  derives: Map[String, JsObject]
) {
  lazy val derivedFields: Map[String, FieldTypeJson] = 
    derives.mapValues(_.as(FieldTypeJson.fmt))
}

case class FieldTypeJson
(
  display_name: String,
  archetype: String,
  has_possible_values: Option[Boolean],
  max_values: Option[Int],
  process: Option[List[ProcessingStepJson]]
)


object ProcessingStepJson {
  implicit val fmt = Json.format[ProcessingStepJson]
}

object FieldTypeJson {
  implicit val fmt = Json.format[FieldTypeJson]
}
