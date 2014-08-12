package swarmize.json

import play.api.libs.json._
import org.joda.time.DateTime
import scala.util.Try
import org.joda.time.format.ISODateTimeFormat
import play.api.libs.json.JsString
import play.api.libs.json.JsSuccess
import play.api.libs.json.JsNumber
import play.api.data.validation.ValidationError

object PlayJsonIsoDateFormat extends Format[DateTime] {
  def writes(d: org.joda.time.DateTime): JsValue = JsString(d.toString)

  def reads(json: JsValue): JsResult[DateTime] = json match {
    case JsNumber(num) => JsSuccess(new DateTime(num.toLong))
    case JsString(s) => Try {
      JsSuccess(ISODateTimeFormat.dateTimeParser().parseDateTime(s))
    }.recover {
      case e: IllegalArgumentException =>
        JsError(ValidationError("validate.error.expected.date.isoformat", s))
    }.get

    case other =>
      JsError(ValidationError("validate.error.expected.date"))
  }
}
