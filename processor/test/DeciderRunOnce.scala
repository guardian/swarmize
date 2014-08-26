import lib.Decider

import scala.concurrent.Await
import scala.concurrent.duration.Duration


object DeciderRunOnce extends App {
  println("Running once!")

  Await.ready(Decider.runAsync(), atMost = Duration.Inf)

  println("COMPLETED!")

  sys.exit(0)
}
