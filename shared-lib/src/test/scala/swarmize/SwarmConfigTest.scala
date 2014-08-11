package swarmize

import org.scalatest._

class SwarmConfigTest extends FlatSpec with Matchers with OptionValues {

  "SwarmConfig" should "return nothing when loading a config that doesn't exist" in {
    SwarmConfig.findByToken("not-found") shouldBe None
  }

}
