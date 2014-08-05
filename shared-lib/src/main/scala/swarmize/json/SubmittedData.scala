package swarmize.json

import play.api.libs.json.{Json, JsValue}
import swarmize.{UniqueId, SwarmConfig}

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
  processingSteps: List[String],

  // the actual data
  data: JsValue
)


object SubmittedData {
  implicit val jsonFormat = Json.format[SubmittedData]

  def wrap(data: JsValue, swarm: SwarmConfig, steps: List[String]): SubmittedData = {
    SubmittedData(
      swarmName = swarm.name,
      swarmToken = swarm.token,
      submissionId = UniqueId.generate,
      processingSteps = steps,
      data = data
    )
  }

}