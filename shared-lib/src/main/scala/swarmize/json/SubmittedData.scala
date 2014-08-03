package swarmize.json

import play.api.libs.json.JsValue

case class SubmittedData(
  data: JsValue,
  swarmName: String,
  swarmKey: String,
  submissionId: String,


}

)


object SubmittedData {

}