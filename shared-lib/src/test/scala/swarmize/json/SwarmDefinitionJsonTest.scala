package swarmize.json

import org.scalatest._
import play.api.libs.json.Json

class SwarmDefinitionJsonTest extends FlatSpec with Matchers with OptionValues {

  val exampleJsonString =
    """
      |{
      |    "name": "Guardian Broadband Survey 2013",
      |    "description": "With your help, the Guardian is creating an up-to-date broadband map of Britain, showing advertised versus real speeds. We want to highlight the best and worst-served communities, and bring attention to the broadband blackspots.",
      |    "fields": [
      |        {
      |            "index": "0",
      |            "field_type": "yesno",
      |            "field_name": "Do you have Internet at home?",
      |            "hint": "This question is about whether you have a landline internet connection rather access to the web through the mobile phone network",
      |            "compulsory": "1"
      |        },
      |        {
      |            "index": "1",
      |            "field_type": "pick_one",
      |            "field_name": "Can you get broadband where you live?",
      |            "hint": "Broadband is defined as 2 megabits per second and over",
      |            "possible_values": ["Yes", "No", "Not sure"],
      |            "compulsory": "1"
      |        },
      |        {
      |            "index": "2",
      |            "field_type": "pick_one",
      |            "field_name": "Who is your broadband provider?",
      |            "hint": "",
      |            "possible_values": ["BT", "Virgin Media", "Sky", "TalkTalk", "O2", "Orange", "PlusNet", "I have no connection"],
      |            "compulsory": "1"
      |        },
      |        {
      |            "index": "3",
      |            "field_type": "pick_one",
      |            "field_name": "What speed does your broadband provider claim you are getting?",
      |            "hint": "select the option closest to yours, (in seconds)",
      |            "possible_values": ["up to 2 megabits", "up to 8 megabits", "up to 12 megabits"],
      |            "compulsory": "1"
      |        },
      |        {
      |            "index": "4",
      |            "field_type": "number",
      |            "field_name": "What is your actual, tested broadband speed?",
      |            "hint": "As tested by you on www.broadbandspeedchecker.co.uk or www.speedtest.net or another speed checker website. To help us process, can you please use this standard format? Number only, and in megabits per second. No need to write mbps. eg: For 8 mbps write 8. For 800 kilobits write 0.8. For 1.2 gigabits write 1200.",
      |            "sample_value": "",
      |            "compulsory": "1"
      |        },
      |        {
      |            "index": "5",
      |            "field_type": "postcode",
      |            "field_name": "What is your postcode?",
      |            "hint": "Please type in the first half of your postcode, for example NG16. The information will not be used for any purpose except this map.",
      |            "sample_value": "",
      |            "compulsory": "1"
      |        },
      |        {
      |            "index": "6",
      |            "field_type": "pick_one",
      |            "field_name": "Are government targets enough to make Britain a world leading internet economy?",
      |            "hint": "",
      |            "possible_values": ["Yes", "No", "Not Sure"]
      |        },
      |        {
      |            "index": "7",
      |            "field_type": "pick_one",
      |            "field_name": "Should the government invest more in broadband?",
      |            "hint": "A total of £1.3bn of taxpayer's money has been set aside for broadband",
      |            "possible_values": ["Yes", "No", "Not Sure"]
      |        },
      |        {
      |            "index": "8",
      |            "field_type": "bigtext",
      |            "field_name": "Anything else? Add your comments here.",
      |            "hint": "",
      |            "sample_value": ""
      |        },
      |        {
      |            "index": "9",
      |            "field_type": "email",
      |            "field_name": "Your details",
      |            "hint": "Please enter your email address. This WILL NOT be published, but is to help us if we have any questions about this form",
      |            "sample_value": "",
      |            "compulsory": "1"
      |        }
      |    ],
      |    "opens_at": null,
      |    "closes_at": null
      |}
    """.stripMargin

  val exampleJson = Json.parse(exampleJsonString)

  "SwarmDefinition" should "be serializable from json" in {
    val definition = exampleJson.as[SwarmDefinition]

    println(definition)

    definition.name shouldBe "Guardian Broadband Survey 2013"
    definition.description shouldBe "With your help, the Guardian is creating an up-to-date broadband map of Britain, showing advertised versus real speeds. We want to highlight the best and worst-served communities, and bring attention to the broadband blackspots."

    definition.opens_at shouldBe None
    definition.closes_at shouldBe None

    definition.fields.size shouldBe 10

    val field = definition.fields(0)

    field.field_name shouldBe "Do you have Internet at home?"

  }

}
