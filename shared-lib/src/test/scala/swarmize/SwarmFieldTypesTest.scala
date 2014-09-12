package swarmize

import org.scalatest._
import swarmize.json.JsonSwarmField

class SwarmFieldTypesTest extends FlatSpec with Matchers with OptionValues {

  "FieldTypes" should "managed to load the json file" in {
    FieldTypes.types should not be empty
  }

  "SwarmField" should "be able to create a mapping for each field type defined" in {
    for (fieldTypeName <- FieldTypes.types.keys) {
      val fieldDefinitionForFieldOfThisType = JsonSwarmField(
        field_name = s"$fieldTypeName Test",
        field_name_code = s"${fieldTypeName}_test",
        field_type= fieldTypeName,
        compulsory = false
      )
      val field = SwarmField(fieldDefinitionForFieldOfThisType)

      field should not be null
    }
  }

}
