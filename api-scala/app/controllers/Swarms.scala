package controllers

import lib.Elasticsearch
import lib.ElasticsearchPromise._
import org.elasticsearch.index.query.QueryBuilders
import org.elasticsearch.search.sort.SortOrder
import play.api.libs.json._
import play.api.mvc._
import swarmize.Swarm

import scala.concurrent.Future
import scala.concurrent.ExecutionContext.Implicits.global

object Swarms extends Controller {

  def show(token: String) = Action {
    val maybeSwarm = Swarm.findByToken(token)

    maybeSwarm.map { swarm =>
      Ok(swarm.definition.toJson)
    } getOrElse {
      NotFound(s"Unknown swarm: $token")
    }
  }

  def results(token: String) = Action.async { req =>
    val maybeSwarm = Swarm.findByToken(token)

    val page = req.getQueryString("page").map(_.toInt).getOrElse(1)
    val pageSize = req.getQueryString("per_page").map(_.toInt).getOrElse(10)

    maybeSwarm.map { swarm =>
      Elasticsearch.client.prepareSearch(swarm.token)
        .setSize(pageSize)
        .setFrom((page - 1) * pageSize)
        .setQuery(QueryBuilders.matchAllQuery())
        .execute().future map { results =>

        val srcDocs = results.getHits.hits().map(_.getSourceAsString).map(Json.parse)

        val result = Json.obj(
          "query_details" -> Json.obj(
            "per_page" -> pageSize,
            "page" -> page,
            "total_pages" -> ((results.getHits.getTotalHits / pageSize) + 1)
          ),
          "results" -> JsArray(srcDocs)
        )
        Ok(result)
      }
    } getOrElse {
      Future.successful(NotFound(s"Unknown swarm: $token"))
    }
  }

  def latest(token: String) = Action.async {
    val maybeSwarm = Swarm.findByToken(token)

    maybeSwarm.map { swarm =>
      Elasticsearch.client.prepareSearch(swarm.token)
        .setSize(1)
        .setQuery(QueryBuilders.matchAllQuery())
        .addSort("timestamp", SortOrder.DESC)
        .execute().future map { results =>

        val srcDoc = results.getHits.hits().headOption.map(_.getSourceAsString).map(Json.parse)

        Ok(srcDoc getOrElse Json.obj())
      }
    } getOrElse {
      Future.successful(NotFound(s"Unknown swarm: $token"))
    }
  }
}
