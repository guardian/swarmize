package swarmize

import play.api.libs.json.{Json, JsNull, JsUndefined, JsValue}
import swarmize.json.JsonSwarmField

import scala.util.Try


sealed trait SwarmField {

  protected def rawJson: json.JsonSwarmField

  def codeName = rawJson.field_name_code
  def fullName = rawJson.field_name

  def fieldType = rawJson.field_type

  def isCompulsory = rawJson.compulsory

  def validate(maybeValue: Option[JsValue]): Try[JsValue] = Try {
    if (isCompulsory && maybeValue.isEmpty)
      sys.error("compulsory field is missing")

    maybeValue getOrElse JsNull
  }

}

case class FreeTextField(rawJson: JsonSwarmField) extends SwarmField

trait FixedTextField extends SwarmField

case class RegexableField(rawJson: JsonSwarmField) extends FixedTextField
case class PickField(rawJson: JsonSwarmField, many: Boolean) extends FixedTextField {
//  override def validate(maybeValue: Option[JsValue]): Try[JsValue] = {
//    super.validate(maybeValue).flatMap(value =>
//    )
//  }
}

case class NumberField(rawJson: JsonSwarmField) extends SwarmField

case class BooleanField(rawJson: JsonSwarmField) extends SwarmField



object SwarmField {
  def apply(json: JsonSwarmField) = json.field_type match {
    case "text" | "bigtext" | "address" | "city" | "county" | "state" | "country" =>
      FreeTextField(json)

    case "postcode" | "email" =>
      RegexableField(json)

    case "pick_one" =>
      PickField(json, many = false)

    case "pick_several" =>
      PickField(json, many = true)

    case "number" | "rating" =>
      NumberField(json)

    case "yesno" | "check_box" =>
      BooleanField(json)

    case other =>
      sys.error("I don't understand field type " + other)

  }
}