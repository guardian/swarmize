package swarmize

import play.api.Logger

trait ClassLogger {
  protected lazy val log = Logger(getClass)


  protected final def logAround[T](msg: String)(block: => T) = {
    log.info(msg + "...")
    val result = block
    log.info(msg + " complete")
    result
  }

}
