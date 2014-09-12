package swarmize

import play.api.libs.json._
import swarmize.json.JsonSwarmField

import scala.math.BigDecimal


sealed trait SwarmField {
  def description: String = s"$codeName: ${getClass.getSimpleName}${if (isCompulsory) " (COMPULSORY)" else ""}"

  def codeName: String

  def isCompulsory: Boolean

  // TODO: THIS IS JUST USED IN THE PostCode processing, which should switch accross to
  // our more general model. This field must code.
  @deprecated("Do Not Use!", since = "12 Sept 2014")
  def fieldType: String = "XXXX"

  def validate(maybeValue: Option[JsValue]): JsResult[JsValue] =
    if (isCompulsory && maybeValue.isEmpty)
      JsError("compulsory field is missing")
    else
      JsSuccess(maybeValue getOrElse JsNull)

}

case class FreeTextField(codeName: String, isCompulsory: Boolean) extends SwarmField



trait TokenField extends SwarmField

case class SimpleTokenField
(
  codeName: String,
  isCompulsory: Boolean,
  override val fieldType: String
  ) extends TokenField

case class PickField
(
  codeName: String,
  isCompulsory: Boolean,
  allowedValues: List[String],
  many: Boolean
  ) extends TokenField {

  //def allowedValues: List[String] = rawJson

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


case class NumberField(codeName: String, isCompulsory: Boolean) extends SwarmField {

}


case class BooleanField(codeName: String, isCompulsory: Boolean) extends SwarmField {
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
  def apply(f: JsonSwarmField): SwarmField = {
    val fieldType = FieldTypes.types(f.field_type)

    fieldType.archetype match {
      case "free_text" =>
        FreeTextField(codeName = f.field_name_code, isCompulsory = f.compulsory)

      case "token" =>
        if (fieldType.has_possible_values contains true)
          PickField(
            codeName = f.field_name_code,
            isCompulsory = f.compulsory,
            allowedValues = f.possible_values.getOrElse(Map.empty).keys.toList,
            many = !(fieldType.max_values contains 1)
          )
        else
          SimpleTokenField(codeName = f.field_name_code, isCompulsory = f.compulsory, fieldType = f.field_type)

      case "boolean" =>
        BooleanField(codeName = f.field_name_code, isCompulsory = f.compulsory)

      case "number" =>
        NumberField(codeName = f.field_name_code, isCompulsory = f.compulsory)

      case other =>
        sys.error("I don't understand archetype " + other)
    }
  }
}