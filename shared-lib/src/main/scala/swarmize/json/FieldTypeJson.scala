package swarmize.json

import play.api.libs.json.{JsObject, Json}

case class ProcessingStepJson
(
  id: String,
  endpoint: String,
  derives: Map[String, String]
)

case class FieldTypeJson
(
  display_name: String,
  archetype: String,
  has_possible_values: Option[Boolean] = None,
  max_values: Option[Int] = None,
  process: Option[List[ProcessingStepJson]] = None
) {
  def processingSteps = process getOrElse Nil
}


object ProcessingStepJson {
  implicit val fmt = Json.format[ProcessingStepJson]
}

object FieldTypeJson {
  implicit val fmt = Json.format[FieldTypeJson]
}
