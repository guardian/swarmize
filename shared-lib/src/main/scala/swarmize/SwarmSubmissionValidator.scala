package swarmize

import org.joda.time.DateTime
import org.joda.time.format.ISODateTimeFormat
import play.api.libs.json.{JsNull, JsValue, Json, JsObject}

import scala.util._

object SwarmSubmissionValidator {
  def validated(swarm: Swarm, jsObject: JsObject): JsObject = {

    val suppliedFields = jsObject.fields.toMap

    val validatedFields: Seq[(String, Try[JsValue])] = swarm.fields.map { f =>
      f.codeName -> f.validate(suppliedFields.get(f.codeName))
    }

    val validationFailures: Seq[String] = validatedFields.collect {
      case (fieldName, Failure(ex)) => s"$fieldName: ${ex.getMessage}"
    }

    if (validationFailures.nonEmpty)
      sys.error("Your submission is invalid:\n" + validationFailures.mkString("\n  ") )

    val fieldValues = validatedFields.collect {
      case (fieldName, Success(fieldValue)) if fieldValue != JsNull => fieldName -> fieldValue
    }

    val result = JsObject(fieldValues)

    println(Json.prettyPrint(result))

    result

  }




}
