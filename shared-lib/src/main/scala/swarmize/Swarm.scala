package swarmize





case class Swarm
(
  token: String,
  definition: json.SwarmDefinition
) {

  def name = definition.name
  def description = definition.description

  lazy val fields: List[SwarmField] = definition.fields.map(SwarmField.apply)

}




object Swarm {

  def findByToken(token: String): Option[Swarm] = SwarmTable.get(token)

}



