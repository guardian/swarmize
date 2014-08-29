package swarmize.json

import play.api.libs.json._
import swarmize.Swarm._
import swarmize.{UniqueId, Swarm}

case class SubmittedData
(
  // unique id of this submission
  //  (this should be used to dedup if necessary)
  submissionId: String,

  // user visible name of the swarm
  swarmName: String,

  // swarm token
  swarmToken: String,

  // state of the swarm at point of submission
  swarmStatus: Swarm.Status,

  // steps to action on this submission
  processingSteps: List[String] = Nil,

  // the actual data
  data: JsValue
) {
  def toJson: JsValue = SubmittedData toJson this
}


object SubmittedData {

  implicit object statusReads extends Reads[Swarm.Status] {
    override def reads(json: JsValue): JsResult[Status] = json match {
      case JsString("Draft") => JsSuccess(Draft)
      case JsString("Open") => JsSuccess(Open)
      case JsString("Closed")  => JsSuccess(Closed)
      case other => JsError("unknown status: " + other)
    }
  }

  implicit object statusWrites extends Writes[Swarm.Status] {
    override def writes(o: Status): JsValue = JsString(o.toString)
  }

  implicit val jsonFormat = Json.format[SubmittedData]


  def wrap(data: JsValue, swarm: Swarm): SubmittedData = {
    SubmittedData(
      swarmName = swarm.name,
      swarmToken = swarm.token,
      swarmStatus = swarm.status,
      submissionId = UniqueId.generateSubmissionId,
      data = data
    )
  }

  def toJson(d: SubmittedData): JsValue = Json toJson d
  def fromJson(j: JsValue): SubmittedData = j.as[SubmittedData]
  def fromJsonString(s: String): SubmittedData = fromJson(Json.parse(s))

}