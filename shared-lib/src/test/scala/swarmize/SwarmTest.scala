package swarmize

import org.joda.time.DateTime
import org.scalatest._
import swarmize.json.SwarmDefinition

class SwarmTest extends FlatSpec with Matchers {

  import Swarm._

  private def swarmWith(open: Option[DateTime] = None, close: Option[DateTime] = None): Swarm = {
    val definition = SwarmDefinition(
      name = "Dummy Swarm",
      description = "Dummy Swarm",
      fields = Nil,
      opens_at = open,
      closes_at = close
    )

    Swarm("dummy", definition)
  }

  "Swarm" should "indicate status correctly" in {
    val now = DateTime.now

    swarmWith(open = None, close = None).status shouldBe Draft
    swarmWith(open = None, close = Some(now plusDays 3)).status shouldBe Draft
    swarmWith(open = Some(now plusDays 2), close = None).status shouldBe Draft
    swarmWith(open = Some(now plusDays 2), close = Some(now plusDays 3)).status shouldBe Draft

    swarmWith(open = Some(now minusDays 2), close = None).status shouldBe Open
    swarmWith(open = Some(now minusDays 2), close = Some(now plusDays 3)).status shouldBe Open

    swarmWith(open = None, close = Some(now minusDays 2)).status shouldBe Closed
    swarmWith(open = Some(now minusDays 3), close = Some(now minusDays 2)).status shouldBe Closed

    // this should never happen, but just in case we should obey the close date as a first priority
    swarmWith(open = Some(now plusDays 2), close = Some(now minusDays 2)).status shouldBe Closed
  }

  it should "calculate dervied fields correctly" in {
    // we rely on this test data
    TestSwarms.broadbandSurvey.fields.map(_.codeName) should contain ("what_is_your_postcode")

    TestSwarms.broadbandSurvey.derivedFields.map(_.codeName) should contain ("what_is_your_postcode_lonlat")
  }

}
