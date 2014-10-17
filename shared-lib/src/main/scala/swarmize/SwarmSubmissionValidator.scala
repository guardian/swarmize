package swarmize

import play.api.data.validation.ValidationError
import play.api.libs.json._

object SwarmSubmissionValidator {

  private def extractErrorMessages(ex: Seq[(JsPath, Seq[ValidationError])]): Seq[String] =
    ex.flatMap {
      case (_, errors) => errors.map(_.message)
    }

  def validated(swarm: Swarm, jsObject: JsObject): JsObject = {

    val suppliedFields = jsObject.fields.toMap

    val validatedFields: Seq[(String, JsResult[JsValue])] = swarm.allFields.map { f =>
      f.codeName -> f.validate(suppliedFields.get(f.codeName))
    }

    val validationFailures: Seq[String] = validatedFields.collect {
      case (fieldName, JsError(ex)) => s"$fieldName: ${extractErrorMessages(ex) mkString ", "}"
    }

    if (validationFailures.nonEmpty)
      sys.error(
        s"""Your submission is invalid:
           | * ${validationFailures mkString "\n * "}""".stripMargin )

    val fieldValues = validatedFields.collect {
      case (fieldName, JsSuccess(fieldValue, _)) if fieldValue != JsNull => fieldName -> fieldValue
    }

    JsObject(fieldValues)
  }
}
