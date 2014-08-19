package swarmize

import play.api.libs.json._
import swarmize.json.JsonSwarmField

import scala.math.BigDecimal


sealed trait SwarmField {
  def description: String = s"$codeName: ${getClass.getSimpleName}${if (isCompulsory) " (COMPULSORY)" else ""}"


  protected def rawJson: json.JsonSwarmField

  def codeName = rawJson.field_name_code
  def fullName = rawJson.field_name

  def fieldType = rawJson.field_type

  def isCompulsory = rawJson.compulsory

  def validate(maybeValue: Option[JsValue]): JsResult[JsValue] =
    if (isCompulsory && maybeValue.isEmpty)
      JsError("compulsory field is missing")
    else
      JsSuccess(maybeValue getOrElse JsNull)

}

case class FreeTextField(rawJson: JsonSwarmField) extends SwarmField



trait FixedTextField extends SwarmField

case class RegexableField(rawJson: JsonSwarmField) extends FixedTextField

case class PickField(rawJson: JsonSwarmField, many: Boolean) extends FixedTextField {

  def allowedValues: List[String] = rawJson.possible_values.getOrElse(Map.empty).keys.toList

  def err = JsError(s"expecting ${if (many) "some" else "one"} of ${allowedValues.mkString(", ")}")

  override def validate(maybeValue: Option[JsValue]): JsResult[JsValue] = {
    super.validate(maybeValue).flatMap {
      case s @ JsString(value) =>
        if (allowedValues contains value)
          JsSuccess(if (many) Json.arr(s) else s)
        else
          err

      case arr @ JsArray(values) if many =>
        if (values.forall { case JsString(s) if allowedValues contains s => true; case _ => false })
          JsSuccess(arr)
        else
          err

      case JsArray(_) if !many => err

      case JsNull => JsSuccess(JsNull)
      case other => JsError("expecting a string, got " + other)
    }
  }
}


case class NumberField(rawJson: JsonSwarmField) extends SwarmField {

}


case class BooleanField(rawJson: JsonSwarmField) extends SwarmField {
  override def validate(maybeValue: Option[JsValue]): JsResult[JsValue] = {
    val TRUE = JsSuccess(JsBoolean(value = true))
    val FALSE = JsSuccess(JsBoolean(value = false))

    super.validate(maybeValue).flatMap {
      case b: JsBoolean => JsSuccess(b)

      case JsString("yes") | JsString("1") | JsString("true") => TRUE
      case JsString("no") | JsString("0") | JsString("false") => FALSE

      case JsNumber(bd) if bd == BigDecimal(1) => TRUE
      case JsNumber(bd) if bd == BigDecimal(0) => FALSE

      case JsNull => JsSuccess(JsNull)

      case other => JsError("""expected one of "yes", "no", 1, 0, true, false""")
    }
  }
}



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