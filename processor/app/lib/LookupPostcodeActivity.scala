package lib

import swarmize.{Swarm, ClassLogger}
import swarmize.json.SubmittedData
import play.api.libs.ws._
import scala.concurrent.Future

import scala.concurrent.ExecutionContext.Implicits.global

object LookupPostcodeActivity extends Activity with ClassLogger {
  val name = "LookupPostcode"
  val version = "1"

  override def process(r: SubmittedData): Future[SubmittedData] = {
    log.info(s"${r.submissionId} lookup postcode running")

    val swarm = Swarm.findByToken(r.swarmToken).get
    val postcodeFields = swarm.fields.filter(_.fieldTypeName == "postcode").map(_.codeName).map("field" -> _)

    import play.api.Play.current

    WS.url("http://swarmizegeocoder-prod.elasticbeanstalk.com/geocode")
      .withQueryString(postcodeFields :_*)
      .post(r.data)
      .map { response =>
        log.info(s"${r.submissionId}: result is ${response.status} ${response.statusText}")

        response.status match {
          case 200 =>
            r.copy(data = response.json)

          case 204 =>
            r

          case other =>
            sys.error(s"lookup failed: ${response.status} ${response.statusText} => ${response.body}")

        }

    }

  }

  override def shouldProcess(s: Swarm): Boolean = {
    s.fields.exists(_.fieldTypeName == "postcode")
  }
}
