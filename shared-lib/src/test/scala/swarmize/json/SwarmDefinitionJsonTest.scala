package swarmize.json

import org.scalatest._
import swarmize.TestSwarms

class SwarmDefinitionJsonTest extends FlatSpec with Matchers with OptionValues {




  "SwarmDefinition" should "be serializable from json" in {
    val definition = TestSwarms.broadbandSurveyJson.as[SwarmDefinition]

    definition.name shouldBe "Guardian Broadband Survey 2013"
    definition.description shouldBe "With your help, the Guardian is creating an up-to-date broadband map of Britain, showing advertised versus real speeds. We want to highlight the best and worst-served communities, and bring attention to the broadband blackspots."

    definition.opens_at.value.getMillis shouldBe 1438513980000L
    definition.closes_at shouldBe None

    definition.fields.size shouldBe 10

    val field = definition.fields(0)

    field.field_name shouldBe "Do you have Internet at home?"
    field.compulsory shouldBe true

  }

}
