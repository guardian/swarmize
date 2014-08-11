package controllers

import play.api._
import play.api.mvc._
import swarmize.UniqueId

object Application extends Controller {

  def index = Action {
    Ok("swarmize: processor")
  }

  def newtoken() = Action {
    Ok(UniqueId.generateSwarmToken)
  }
}