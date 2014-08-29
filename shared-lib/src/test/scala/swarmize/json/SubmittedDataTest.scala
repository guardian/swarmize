package swarmize.json

import org.scalatest._
import play.api.libs.json.Json
import swarmize.{TestSwarms, Swarm}

class SubmittedDataTest extends FlatSpec with Matchers with OptionValues {

  "Submitted Data" should "wrap submitted submission" in {
    val rawSubmission = """
      {"user_key":12345,"timestamp":1407228014,"intent":"green",
      "feedback": "Mr King","postcode":"N1 9GU","ip":"10.0.0.1"}
    """

    val submissionJson = Json.parse(rawSubmission)

    val wrapped = SubmittedData.wrap(submissionJson, TestSwarms.simpleSurvey)

    val id = wrapped.submissionId

    val string = Json.toJson(wrapped).toString()

    string shouldBe
      s"""{"submissionId":"$id","swarmName":"A very simple survey","swarmToken":"test-simple",
         |"swarmStatus":"Draft",
         |"processingSteps":[],
         |"data":{"user_key":12345,"timestamp":1407228014,"intent":"green","feedback":"Mr King","postcode":"N1 9GU","ip":"10.0.0.1"}}"""
        .stripMargin.replace("\n", "")


    Json.parse(string).as[SubmittedData] shouldBe wrapped

  }

}
