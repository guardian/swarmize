import lib.{Activity, ActivityDispatcher, Decider}
import play.api.{Application, GlobalSettings, Logger}
import swarmize.aws.SimpleWorkflow


object Global extends GlobalSettings {

  override def onStart(app: Application) {
    Logger.info("On start")

    Activity.registerAll()
    SimpleWorkflow.registerWorkflow()

    new Thread(new Decider()).start()
    new Thread(new ActivityDispatcher()).start()

  }

  override def onStop(app: Application) {
    Logger.info("On stop")
  }
}
