package swarmize.json

import org.joda.time.DateTime
import play.api.libs.json.{JsValue, Json}

case class SwarmDefinition
(
  name: String,
  description: String,

  fields: List[SwarmField],
  opens_at: Option[DateTime],
  closes_at: Option[DateTime]
) {
  def toJson = SwarmDefinition toJson this

}

case class SwarmField
(
  index: String,
  field_type: String,
  field_name: String,
  hint: String,
  sample_value: Option[String],
  compulsory: Option[String]
)

object SwarmDefinition {
  implicit val fieldJsonFormat = Json.format[SwarmField]
  implicit val definitionJsonFormat = Json.format[SwarmDefinition]

  def toJson(d: SwarmDefinition): JsValue = Json toJson d
}