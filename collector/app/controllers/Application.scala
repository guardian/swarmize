package controllers

import play.api.mvc._
import swarmize.FieldTypes

object Application extends Controller {

  def index = Action {
    Ok(FieldTypes.json)
    //Ok("swarmize: collector")
  }

}