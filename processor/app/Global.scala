import lib.{Activity, ActivityDispatcher, Decider}
import play.api.{GlobalSettings, Logger, Application}
import swarmize.aws.SimpleWorkflow

import scala.concurrent.Future
import scala.concurrent.ExecutionContext.Implicits.global


object Global extends GlobalSettings {

  override def onStart(app: Application) {
    Logger.info("On start")

    Activity.registerAll()
    SimpleWorkflow.registerWorkflow()

    Future {
      new Decider().run()
    }

    Future {
      new ActivityDispatcher().run()
    }

  }

  override def onStop(app: Application) {
    Logger.info("On stop")
  }
}
