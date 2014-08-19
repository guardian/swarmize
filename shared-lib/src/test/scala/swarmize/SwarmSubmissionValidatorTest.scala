package swarmize

import org.scalatest._
import play.api.libs.json.{JsBoolean, Json}

class SwarmSubmissionValidatorTest extends FlatSpec with Matchers with OptionValues {
  val swarm = TestSwarms.simpleSurvey

  "SwarmSubmissionValidator" should "complain about missing fields" in {
    val inputWithMissingMandatoryFields = Json.obj(
      "age" -> "27"
    )

    val thrown = the [RuntimeException] thrownBy
      SwarmSubmissionValidator.validated(swarm, inputWithMissingMandatoryFields)

    thrown.getMessage shouldBe "Your submission is invalid:\n * what_is_your_name: compulsory field is missing"
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

  it should "fail if pick one fields don't contain one of the values expected" in {
    val input = Json.obj("what_is_your_name" -> "Sara", "what_is_your_age" -> "as_young_as_you_feel")

    val thrown = the [RuntimeException] thrownBy
      SwarmSubmissionValidator.validated(swarm, input)

    thrown.getMessage shouldBe "Your submission is invalid:\n * what_is_your_age: expecting one of young, not_sure, old"
  }

  it should "fail if pick one fields contain multiple values" in {
    val input = Json.obj("what_is_your_name" -> "Sara", "what_is_your_age" -> Json.arr("young", "old"))

    val thrown = the [RuntimeException] thrownBy
      SwarmSubmissionValidator.validated(swarm, input)

    thrown.getMessage shouldBe "Your submission is invalid:\n * what_is_your_age: expecting one of young, not_sure, old"
  }

  it should "pass if pick one field contains the value expected" in {
    val input = Json.obj("what_is_your_name" -> "Julia", "what_is_your_age" -> "not_sure")

    SwarmSubmissionValidator.validated(swarm, input).keys shouldBe
      Set("what_is_your_name", "what_is_your_age")

  }

  it should "pass if pick many fields contains just expected values" in {
    val input = Json.obj("what_is_your_name" -> "Popeye", "whats_your_favourite_day" -> "mon")

    SwarmSubmissionValidator.validated(swarm, input).keys shouldBe
      Set("what_is_your_name", "whats_your_favourite_day")

    val inputArr = Json.obj("what_is_your_name" -> "Popeye", "whats_your_favourite_day" -> Json.arr("mon", "sun"))

    SwarmSubmissionValidator.validated(swarm, inputArr).keys shouldBe
      Set("what_is_your_name", "whats_your_favourite_day")

  }

  it should "fail if pick many fields contain unexpected values" in {
    val input = Json.obj("what_is_your_name" -> "Riff Raff", "whats_your_favourite_day" -> "september")

    val thrown = the [RuntimeException] thrownBy
      SwarmSubmissionValidator.validated(swarm, input)

    thrown.getMessage shouldBe "Your submission is invalid:\n * whats_your_favourite_day: expecting some of sat, sun, mon"

  }

  it should "parse yes no and boolean fields" in {
    val input = Json.obj("what_is_your_name" -> "Billy", "do_you_have_a_favourite_colour" -> "yes")

    SwarmSubmissionValidator.validated(swarm, input) \ "do_you_have_a_favourite_colour" shouldBe JsBoolean(value = true)

    val input2 = Json.obj("what_is_your_name" -> "Billy", "do_you_have_a_favourite_colour" -> 0)

    SwarmSubmissionValidator.validated(swarm, input2) \ "do_you_have_a_favourite_colour" shouldBe JsBoolean(value = false)

  }

}
