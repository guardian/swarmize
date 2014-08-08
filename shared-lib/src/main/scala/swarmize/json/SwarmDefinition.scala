package swarmize.json

import org.joda.time.DateTime
import play.api.libs.json.Json

case class SwarmDefinition
(
  name: String,
  description: String,

  fields: List[SwarmField],
  opens_at: Option[DateTime],
  closes_at: Option[DateTime]
) {

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
}