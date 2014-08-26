package swarmize.json

import play.api.libs.json.{Json, JsValue}
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

  // steps to action on this submission
  processingSteps: List[String] = Nil,

  // the actual data
  data: JsValue
) {
  def toJson: JsValue = SubmittedData toJson this
}


object SubmittedData {
  implicit val jsonFormat = Json.format[SubmittedData]

  def wrap(data: JsValue, swarm: Swarm): SubmittedData = {
    SubmittedData(
      swarmName = swarm.name,
      swarmToken = swarm.token,
      submissionId = UniqueId.generateSubmissionId,
      data = data
    )
  }

  def toJson(d: SubmittedData): JsValue = Json toJson d
  def fromJson(j: JsValue): SubmittedData = j.as[SubmittedData]
  def fromJsonString(s: String): SubmittedData = fromJson(Json.parse(s))

}