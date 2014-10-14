package controllers

import lib.Elasticsearch
import lib.ElasticsearchPromise._
import org.elasticsearch.index.query.QueryBuilders
import org.elasticsearch.search.aggregations.AggregationBuilders
import org.elasticsearch.search.aggregations.bucket.terms.Terms
import org.elasticsearch.search.sort.SortOrder
import play.api.libs.json._
import play.api.mvc._
import swarmize._

import scala.collection.convert.wrapAll._
import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.Future

object Swarms extends Controller {

  private def swarmAction(token: String)(block: Swarm => Future[Result]) = Action.async { req =>
    Swarm.findByToken(token).map(block)
      .getOrElse(Future.successful(NotFound(s"Unknown swarm: $token")))
  }

  def show(token: String) = swarmAction(token) { swarm =>
    Future.successful(Ok(swarm.definition.toJson))
  }

  def results(token: String, page: Int, pageSize: Int) = swarmAction(token) { swarm =>
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
  }

  def latest(token: String) = swarmAction(token) { swarm =>
    Elasticsearch.client.prepareSearch(swarm.token)
      .setSize(1)
      .setQuery(QueryBuilders.matchAllQuery())
      .addSort("timestamp", SortOrder.DESC)
      .execute().future map { results =>

      val srcDoc = results.getHits.hits().headOption.map(_.getSourceAsString).map(Json.parse)

      Ok(srcDoc getOrElse Json.obj())
    }
  }


  def counts(token: String) = swarmAction(token) { swarm =>

    val countableFields = swarm.allFields.collect {
      case b: BooleanField => b
      case pick: PickField => pick
    }

    val req = Elasticsearch.client.prepareSearch(swarm.token)
      .setSize(0)
      .setQuery(QueryBuilders.matchAllQuery())

    countableFields.foreach { f =>
      req.addAggregation(AggregationBuilders.terms(f.codeName).field(f.codeName))
    }

    req.execute().future map { results =>
      val objs = results.getAggregations.asList zip countableFields map { case (agg, field) =>
        Json.obj(
          "field_name" -> field.fullName,
          "field_name_code" -> field.codeName,
          "counts" -> JsArray(
            agg.asInstanceOf[Terms].getBuckets.toSeq.map(b =>
              Json.obj(b.getKey -> b.getDocCount)
            )
          )
        )
      }

      Ok(JsArray(objs))
    }
  }
}
