package swarmize

import org.scalatest._

class SwarmTest extends FlatSpec with Matchers with OptionValues {

  "SwarmConfig" should "return nothing when loading a config that doesn't exist" in {
    Swarm.findByToken("not-found") shouldBe None
  }

}
