import lib.{ActivityDispatcher, Decider}

object ActivityRunOnce extends App {
  println("Running once!")

  new ActivityDispatcher().runOnce()
}