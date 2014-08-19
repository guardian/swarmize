import lib.{Activity, ActivityDispatcher, Decider}
import play.api.{Application, GlobalSettings, Logger}
import swarmize.aws.SimpleWorkflowConfig


object Global extends GlobalSettings {

  override def onStart(app: Application) {
    Logger.info("On start")

    Activity.registerAll()
    SimpleWorkflowConfig.registerWorkflow()

    Decider.run()
    ActivityDispatcher.run()

  }

  override def onStop(app: Application) {
    Logger.info("On stop")
  }
}
