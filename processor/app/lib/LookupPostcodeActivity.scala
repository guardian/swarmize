package lib

import swarmize.{Swarm, ClassLogger}
import swarmize.json.SubmittedData

import scala.concurrent.Future

object LookupPostcodeActivity extends Activity with ClassLogger {
  val name = "LookupPostcode"
  val version = "1"

  override def process(r: SubmittedData): Future[SubmittedData] = {
    log.info(s"${r.submissionId} NO-OP lookup postcode running")
    Future.successful(r)
  }

  override def shouldProcess(s: Swarm): Boolean = {
    s.fields.exists(_.fieldType == "postcode")
  }
}
