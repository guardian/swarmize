package swarmize

import org.scalatest._
import play.api.libs.json.Json

class SwarmSubmissionValidatorTest extends FlatSpec with Matchers with OptionValues {

  "SwarmSubmissionValidator" should "complain about missing fields" in {
    val inputWithMissingMandatoryFields = Json.obj(
      "do_you_have_internet_at_home" -> "no"
    )

    SwarmSubmissionValidator.validate(TestSwarms.broadbandSurvey, inputWithMissingMandatoryFields)

    // TODO!
    (pending)
  }

}
