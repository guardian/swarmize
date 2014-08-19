import lib.Decider

import scala.concurrent.Await
import scala.concurrent.duration.Duration


object DeciderRunOnce extends App {
  println("Running once!")

  val result = Await.result(Decider.runAsync(), atMost = Duration.Inf)

  println(result)
}
