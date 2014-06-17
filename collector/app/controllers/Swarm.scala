package controllers

import play.api.mvc._
import lib.SwarmConfig
import play.api.libs.json.{JsValue, Json}
import org.apache.avro.Schema
import org.apache.avro.generic.{GenericDatumReader, GenericDatumWriter, GenericRecord}
import org.apache.avro.io.DecoderFactory
import scala.util.control.NonFatal
import play.api.Logger

object Swarm extends Controller {

  def show(token: String) = Action {
    val config = SwarmConfig.findByToken(token)

    config.map { c =>
      val msg =
        s"""
          |Swarm name: ${c.name}
          |
          |Schema:
          |${c.submissionSchema.toString(true)}
        """.stripMargin

      Ok(msg)
    } getOrElse {
      NotFound(s"Unknown token: $token")
    }
  }

  def submit(token: String) = Action(parse.tolerantText) { request =>
    val config = SwarmConfig.findByToken(token)
    val text = request.body

    config.map { c =>
      try {
        val doc = buildAvroDocFromJson(text, c.submissionSchema)
        val msg = s"submitted to ${c.name}:\n$doc\n"
        Logger.info(msg)
        Ok(msg)
      } catch {
        case NonFatal(e) =>
          Logger.warn("submission failed", e)
          BadRequest(e.toString + "\n")
      }
    } getOrElse {
      NotFound(s"Unknown token: $token")
    }
  }

  private def buildAvroDocFromJson(json: String, schema: Schema): GenericRecord = {
    val reader = new GenericDatumReader[GenericRecord](schema)
    val jsonDecoder = DecoderFactory.get().jsonDecoder(schema, json)
    reader.read(null, jsonDecoder)
  }
}
