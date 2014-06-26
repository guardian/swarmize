package lib

import org.scalatest._

class SwarmConfigTest extends FlatSpec with Matchers with OptionValues {

  "SwarmConfig" should "return nothing when loading a config that doesn't exist" in {
    SwarmConfig.findByToken("not-found") shouldBe None
  }

  it should "load valid schemas" in {
    val result = SwarmConfig.findByToken("voting").value

    result.name shouldBe "Voting Intentions"
    result.submissionSchema shouldNot be (null)

    println(result.submissionSchema.toString(true))
  }
}
