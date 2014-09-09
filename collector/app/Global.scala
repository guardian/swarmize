import play.api.http.HeaderNames
import play.api.mvc.{Filter, RequestHeader, Result, WithFilters}

import scala.concurrent.Future

import scala.concurrent.ExecutionContext.Implicits.global

object Global extends WithFilters(AddCorsHeaderFilter) {
}


object AddCorsHeaderFilter extends Filter {
  override def apply(nextFilter: (RequestHeader) => Future[Result])(req: RequestHeader): Future[Result] = {
    nextFilter(req) map (
      _.withHeaders(HeaderNames.ACCESS_CONTROL_ALLOW_ORIGIN -> "*")
    )
  }
}