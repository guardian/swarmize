import lib.Decider


object DeciderRunOnce extends App {
  println("Running once!")

  new Decider().runOnce()
}
