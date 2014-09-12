package swarmize

import play.api.libs.json._
import swarmize.json.{ProcessingStepJson, JsonSwarmField}

import scala.math.BigDecimal


sealed trait SwarmField {
  def description: String = s"$codeName: ${getClass.getSimpleName}${if (isCompulsory) " (COMPULSORY)" else ""}"

  protected def underlyingDefinition: json.JsonSwarmField

  def codeName = underlyingDefinition.field_name_code
  def fullName = underlyingDefinition.field_name

  def isCompulsory = underlyingDefinition.compulsory

  lazy val fieldType = FieldTypes(underlyingDefinition.field_type)

  lazy val derivedFields: List[SwarmField] = {
    fieldType.processingSteps
      .flatMap(_.derives)
      .map { case (suffix, derivedFieldType) =>
        json.JsonSwarmField(
          field_name = "Derived field",
          field_name_code = codeName + suffix,
          field_type = derivedFieldType,
          compulsory = false
        )
      }
      .map(SwarmField.apply)
  }

  def processors: List[ProcessingStepJson] = fieldType.processingSteps

  def validate(maybeValue: Option[JsValue]): JsResult[JsValue] =
    if (isCompulsory && maybeValue.isEmpty)
      JsError("compulsory field is missing")
    else
      JsSuccess(maybeValue getOrElse JsNull)

}

case class FreeTextField(underlyingDefinition: json.JsonSwarmField) extends SwarmField



sealed trait TokenField extends SwarmField

case class SimpleTokenField(underlyingDefinition: json.JsonSwarmField) extends TokenField

case class PickField
(
  underlyingDefinition: json.JsonSwarmField,
  many: Boolean
) extends TokenField {

  def allowedValues = underlyingDefinition.possible_values.getOrElse(Map.empty).keys.toList

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


case class NumberField(underlyingDefinition: json.JsonSwarmField) extends SwarmField 


case class BooleanField(underlyingDefinition: json.JsonSwarmField) extends SwarmField {
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


case class GeoPointField(underlyingDefinition: json.JsonSwarmField) extends SwarmField



object SwarmField {
  def apply(f: JsonSwarmField): SwarmField = {
    val fieldType = FieldTypes.types(f.field_type)

    fieldType.archetype match {
      case "free_text" =>
        FreeTextField(f)

      case "token" =>
        if (fieldType.has_possible_values contains true)
          PickField(f, many = !(fieldType.max_values contains 1))
        else
          SimpleTokenField(f)

      case "boolean" =>
        BooleanField(f)

      case "number" =>
        NumberField(f)

      case "geopoint" =>
        GeoPointField(f)

      case other =>
        sys.error("I don't understand archetype " + other)
    }
  }
}