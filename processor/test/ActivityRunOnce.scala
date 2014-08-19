import lib.ActivityDispatcher

import scala.concurrent.Await
import scala.concurrent.duration.Duration

object ActivityRunOnce extends App {
  println("Running once!")

  val result = Await.result(ActivityDispatcher.runAsync(), atMost = Duration.Inf)

  println(result)

}