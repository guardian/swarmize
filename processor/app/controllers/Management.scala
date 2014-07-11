package controllers

import lib.Elasticsearch
import play.api.mvc.{Controller, Action}

object Management extends Controller {
  def healthCheck() = Action {
    val resp = Elasticsearch.client.admin().indices().prepareStats().get()

    Ok(s"All good: $resp")
  }
}