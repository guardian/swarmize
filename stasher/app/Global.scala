import lib.KinesisWorker
import play.api.{GlobalSettings, Logger, Application}


object Global extends GlobalSettings {
  override def onStart(app: Application) {
    Logger.info("On start")
    KinesisWorker.start()
  }

  override def onStop(app: Application) {
    Logger.info("On stop")
  }
}
