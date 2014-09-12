package lib

import play.api.libs.ws.WS
import swarmize.{ClassLogger, Swarm, FieldTypes}
import swarmize.json.SubmittedData

import scala.concurrent.Future
import scala.concurrent.ExecutionContext.Implicits.global


class ExternalActivity
(
  override val name: String,
  endpoint: String
  ) extends Activity with ClassLogger {

  override def version: String = "1"

  override def process(r: SubmittedData): Future[SubmittedData] = {
    log.info(s"${r.submissionId} $name running")

    val swarm = Swarm.findByToken(r.swarmToken).get
    val fields = swarm.fields.filter(_.processors.exists(_.id == name))
      .map(_.codeName)
      .map("field" -> _)

    import play.api.Play.current

    log.info(s"${r.submissionId}:  invoking $endpoint with $fields")

    WS.url(endpoint)
      .withQueryString(fields :_*)
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

}


object ExternalActivity {
  val all = FieldTypes.processors map { p =>
    new ExternalActivity(p.id, p.endpoint)
  }
}
