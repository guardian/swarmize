package swarmize

import org.scalatest._
import play.api.libs.json.Json

class SwarmSubmissionValidatorTest extends FlatSpec with Matchers with OptionValues {
  val swarm = TestSwarms.simpleSurvey

  "SwarmSubmissionValidator" should "complain about missing fields" in {
    val inputWithMissingMandatoryFields = Json.obj(
      "age" -> "27"
    )

    val thrown = the [RuntimeException] thrownBy
      SwarmSubmissionValidator.validated(swarm, inputWithMissingMandatoryFields)

    thrown.getMessage shouldBe "Your submission is invalid:\nwhat_is_your_name: compulsory field is missing"
  }

  it should "pass if all mandatory fields are supplied" in {
    val input = Json.obj("what_is_your_name" -> "Bob")

    val output = SwarmSubmissionValidator.validated(swarm, input)

    output.keys shouldBe Set("what_is_your_name")
  }

  it should "remove extra fields not defined in the swarm" in {
    val input = Json.obj("what_is_your_name" -> "Jim", "bananas_are" -> "Yellow")

    SwarmSubmissionValidator.validated(swarm, input).keys shouldBe
      Set("what_is_your_name")
  }

  it should "check that pick one fields contain one of the values expected" in {
    val input = Json.obj("what_is_your_name" -> "Sara", "what_is_your_age" -> "as_young_as_you_feel")

    val thrown = the [RuntimeException] thrownBy
      SwarmSubmissionValidator.validated(swarm, input)

    thrown.getMessage shouldBe "Your submission is invalid:\nwhat_is_your_age: expecting one of young, not_sure, old"

  }

}
