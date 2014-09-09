package swarmize

import org.scalatest._

class SwarmFieldTypesTest extends FlatSpec with Matchers with OptionValues {

  "FieldTypes" should "correctly load the json file" in {

    println(FieldTypes.json)

    println(FieldTypes.types)
  }

}
