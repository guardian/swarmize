package swarmize

import play.api.libs.json.Json
import swarmize.json.SwarmDefinition

object TestSwarms {

  val broadbandSurveyJsonString =
    """
      |{
      |    "name": "Guardian Broadband Survey 2013",
      |    "opens_at": "2015-08-02T11:13:00.000Z",
      |    "closes_at": null,
      |    "description": "With your help, the Guardian is creating an up-to-date broadband map of Britain, showing advertised versus real speeds. We want to highlight the best and worst-served communities, and bring attention to the broadband blackspots.",
      |    "fields": [
      |        {
      |            "compulsory": true,
      |            "field_name": "Do you have Internet at home?",
      |            "field_name_code": "do_you_have_internet_at_home",
      |            "field_type": "yesno"
      |        },
      |        {
      |            "compulsory": true,
      |            "field_name": "Can you get broadband where you live?",
      |            "field_name_code": "can_you_get_broadband_where_you_live",
      |            "field_type": "pick_one",
      |            "possible_values": {
      |                "no": "No",
      |                "not_sure": "Not sure",
      |                "yes": "Yes"
      |            }
      |        },
      |        {
      |            "compulsory": true,
      |            "field_name": "Who is your broadband provider?",
      |            "field_name_code": "who_is_your_broadband_provider",
      |            "field_type": "pick_one",
      |            "allow_other": true,
      |            "possible_values": {
      |                "bt": "BT",
      |                "i_have_no_connection": "I have no connection",
      |                "o2": "O2",
      |                "orange": "Orange",
      |                "plusnet": "PlusNet",
      |                "sky": "Sky",
      |                "talktalk": "TalkTalk",
      |                "virgin_media": "Virgin Media"
      |            }
      |        },
      |        {
      |            "compulsory": true,
      |            "field_name": "What speed does your broadband provider claim you are getting?",
      |            "field_name_code": "what_speed_does_your_broadband_provider_claim_you_are_getting",
      |            "field_type": "pick_one",
      |            "possible_values": {
      |                "up_to_12_megabits": "up to 12 megabits",
      |                "up_to_2_megabits": "up to 2 megabits",
      |                "up_to_8_megabits": "up to 8 megabits"
      |            }
      |        },
      |        {
      |            "compulsory": true,
      |            "field_name": "What is your actual, tested broadband speed?",
      |            "field_name_code": "what_is_your_actual_tested_broadband_speed",
      |            "field_type": "number"
      |        },
      |        {
      |            "compulsory": true,
      |            "field_name": "What is your postcode?",
      |            "field_name_code": "what_is_your_postcode",
      |            "field_type": "postcode"
      |        },
      |        {
      |            "compulsory": false,
      |            "field_name": "Are government targets enough to make Britain a world leading internet economy?",
      |            "field_name_code": "are_government_targets_enough_to_make_britain_a_world_leading_internet_economy",
      |            "field_type": "pick_one",
      |            "possible_values": {
      |                "no": "No",
      |                "not_sure": "Not Sure",
      |                "yes": "Yes"
      |            }
      |        },
      |        {
      |            "compulsory": false,
      |            "field_name": "Should the government invest more in broadband?",
      |            "field_name_code": "should_the_government_invest_more_in_broadband",
      |            "field_type": "pick_one",
      |            "possible_values": {
      |                "no": "No",
      |                "not_sure": "Not Sure",
      |                "yes": "Yes"
      |            }
      |        },
      |        {
      |            "compulsory": false,
      |            "field_name": "Anything else? Add your comments here.",
      |            "field_name_code": "anything_else_add_your_comments_here",
      |            "field_type": "bigtext"
      |        },
      |        {
      |            "compulsory": true,
      |            "field_name": "Your details",
      |            "field_name_code": "your_details",
      |            "field_type": "email"
      |        }
      |    ]
      |}
    """.stripMargin


  val broadbandSurveyJson = Json.parse(TestSwarms.broadbandSurveyJsonString)

  lazy val broadbandSurvey = Swarm("test-broadband", broadbandSurveyJson.as[SwarmDefinition])





  val simpleSurveyJsonString =
    """
      |{
      |    "name": "A very simple survey",
      |    "opens_at": "2015-08-02T11:13:00.000Z",
      |    "closes_at": null,
      |    "description": "Without many fields.",
      |    "fields": [
      |        {
      |            "compulsory": true,
      |            "field_name": "What is your name?",
      |            "field_name_code": "what_is_your_name",
      |            "field_type": "text"
      |        },
      |        {
      |            "compulsory": false,
      |            "field_name": "What is your age?",
      |            "field_name_code": "what_is_your_age",
      |            "field_type": "pick_one",
      |            "allow_other": true,
      |            "possible_values": {
      |                "young": "Young",
      |                "not_sure": "Not sure",
      |                "old": "Old"
      |            }
      |        },
      |        {
      |            "compulsory": false,
      |            "field_name": "What's your favourite day?",
      |            "field_name_code": "whats_your_favourite_day",
      |            "field_type": "pick_several",
      |            "possible_values": {
      |                "sat": "Saturday",
      |                "sun": "Sunday",
      |                "mon": "Monday"
      |            }
      |        },
      |        {
      |            "compulsory": false,
      |            "field_name": "Do you have a favourite colour?",
      |            "field_name_code": "do_you_have_a_favourite_colour",
      |            "field_type": "yesno"
      |        }
      |
      |    ]
      |}
    """.stripMargin

  val simpleSurveyJson = Json.parse(TestSwarms.simpleSurveyJsonString)

  lazy val simpleSurvey = Swarm("test-simple", simpleSurveyJson.as[SwarmDefinition])


}
