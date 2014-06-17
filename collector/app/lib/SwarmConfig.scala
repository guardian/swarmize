package lib

import org.apache.avro.Schema
import com.swarmize.VotingIntent


case class SwarmConfig
(
  name: String,
  submissionSchema: Schema
)

// This is just a placeholder for something that will probably be a real service
object SwarmConfig {

  def findByToken(token: String): Option[SwarmConfig] = token match {
    case "banana" => Some(SwarmConfig("Voting Intentions", VotingIntent.getClassSchema))
    case _ => None
  }


}
