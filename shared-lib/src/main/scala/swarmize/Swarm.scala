package swarmize





case class Swarm
(
  token: String,
  definition: json.SwarmDefinition
) {
  def name = definition.name
  def description = definition.description

  lazy val fields = definition.fields.map(new Field(_))


  class Field(raw: json.SwarmField) {
    def codeName = raw.field_name_code
    def fullName = raw.field_name

    def fieldType = raw.field_type
  }

}




object Swarm {

  def findByToken(token: String): Option[Swarm] = SwarmTable.get(token)

}



