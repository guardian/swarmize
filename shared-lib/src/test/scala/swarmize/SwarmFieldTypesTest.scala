package swarmize

import org.scalatest._
import swarmize.json.{FieldTypeJson, JsonSwarmField}

class SwarmFieldTypesTest extends FlatSpec with Matchers with OptionValues {

  "FieldTypes" should "managed to load the json file" in {
    FieldTypes.types should not be empty
  }

  def fieldDefinitionForFieldOfType(fieldTypeName: String) =
    JsonSwarmField(
      field_name = s"$fieldTypeName Test",
      field_name_code = s"${fieldTypeName}_test",
      field_type= fieldTypeName,
      compulsory = false
    )

  "SwarmField" should "be able to create a mapping for each field type defined" in {
    for (fieldTypeName <- FieldTypes.types.keys) {
      val field = SwarmField(fieldDefinitionForFieldOfType(fieldTypeName))
      field should not be null
    }
  }


  it should "expose processing and derived fields" in {
    val postcode = FieldTypes.types("postcode")

    postcode.process.value.size shouldBe 1

    val step1 = postcode.process.value.head

    step1.endpoint shouldBe "http://swarmizegeocoder-prod.elasticbeanstalk.com/geocode"
    step1.derives shouldBe Map(
      "_lonlat" -> "geolocation"
    )

    val fieldDef = fieldDefinitionForFieldOfType("postcode")

    val field = SwarmField(fieldDef)

    field.derivedFields.size shouldBe 1
  }
}
