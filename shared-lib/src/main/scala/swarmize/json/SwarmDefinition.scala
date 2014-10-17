package swarmize.json

import org.joda.time.DateTime
import play.api.libs.json.{JsValue, Json}



case class JsonSwarmField
(
  field_name: String,
  field_name_code: String,
  field_type: String,
  possible_values: Option[Map[String, String]] = None,
  sample_value: Option[String] = None,
  compulsory: Boolean,
  allow_other: Option[Boolean] = None
)


case class SwarmDefinition
(
  name: String,
  description: String,

  fields: List[JsonSwarmField],
  opens_at: Option[DateTime],
  closes_at: Option[DateTime]
) {
  def toJson = SwarmDefinition toJson this
}




object SwarmDefinition {
  implicit val dateFormat = PlayJsonIsoDateFormat
  implicit val fieldJsonFormat = Json.format[JsonSwarmField]
  implicit val definitionJsonFormat = Json.format[SwarmDefinition]

  def toJson(d: SwarmDefinition): JsValue = Json toJson d
}