package controllers

import org.apache.avro.Schema
import org.apache.avro.generic.{GenericDatumReader, GenericRecord}
import org.apache.avro.io.DecoderFactory
import play.api.Logger
import play.api.mvc._
import swarmize.SwarmConfig
import swarmize.aws.SimpleWorkflow

import scala.util.control.NonFatal

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

  def submit(token: String) = Action(parse.tolerantJson) { request =>
    val config = SwarmConfig.findByToken(token)
    val json = request.body

    config.map { c =>
      try {


        val fullObject = c.wrapWithMetadata(json)

        val msg = s"submission to ${c.name}:\n$fullObject\n"

        SimpleWorkflow.submit(fullObject)
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
