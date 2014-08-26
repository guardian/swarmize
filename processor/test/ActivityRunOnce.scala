import lib.ActivityDispatcher

import scala.concurrent.Await
import scala.concurrent.duration.Duration

object ActivityRunOnce extends App {
  println("Running once!")

  Await.ready(ActivityDispatcher.runAsync(), atMost = Duration.Inf)

  println("COMPLETED!")

  sys.exit(0)

}