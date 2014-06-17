import com.swarmize.{Party, VotingIntent}

object VotingIntentDemo extends App {
   println("hi")

   val votingIntent = VotingIntent.newBuilder()
     .setUserid("abcdefghi")
     .setVotingIntention(Party.LIBDEM)
     .setWinningPerson("David Cameron")
     .build()

   println(votingIntent.toString)

 }
