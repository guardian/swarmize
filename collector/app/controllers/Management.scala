package controllers

import play.api.mvc.{Controller, Action}

object Management extends Controller {
  def healthCheck() = Action {
    Ok("All good")
  }
}