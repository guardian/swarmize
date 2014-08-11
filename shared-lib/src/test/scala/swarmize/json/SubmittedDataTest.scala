package swarmize.json

import org.scalatest._
import play.api.libs.json.Json
import swarmize.SwarmConfig

class SubmittedDataTest extends FlatSpec with Matchers with OptionValues {

  "Submitted Data" should "wrap submitted submission" in {
    val rawSubmission = """
      {"user_key":12345,"timestamp":1407228014,"intent":"green",
      "feedback": "Mr King","postcode":"N1 9GU","ip":"10.0.0.1"}
    """

    val submissionJson = Json.parse(rawSubmission)

    // TODO: create a way to create dummy config for testing
//    val swarmConfig = SwarmConfig.findByToken("voting").value
//
//    val wrapped = SubmittedData.wrap(submissionJson, swarmConfig, List("SomeProcessingStep"))
//
//    val id = wrapped.submissionId
//
//    Json.toJson(wrapped).toString shouldBe
//      s"""{"submissionId":"$id","swarmName":"Voting Intentions","swarmToken":"voting",
//         |"processingSteps":["SomeProcessingStep"],
//         |"data":{"user_key":12345,"timestamp":1407228014,"intent":"green","feedback":"Mr King","postcode":"N1 9GU","ip":"10.0.0.1"}}"""
//        .stripMargin.replace("\n", "")

  }

}
