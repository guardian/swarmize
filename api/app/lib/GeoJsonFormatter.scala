package lib

import play.api.libs.json._

object GeoJsonFormatter {

  def format(src: List[JsValue], key: String): JsObject = {

    val features = src map { objvalue =>
      val obj = objvalue.as[JsObject]
      val geoPoint = makeGeoPointDoubles(obj \ key)
      val props = obj - key

      Json.obj(
        "type" -> "Feature",
        "geometry" -> Json.obj(
          "type" -> "Point",
          "coordinates" -> geoPoint
        ),
        "properties" -> props
      )

    }

    Json.obj(
      "type" -> "FeatureCollection",
      "features" -> features
    )
  }

  private def makeGeoPointDoubles(pt: JsValue): JsValue = {
    val arrValues = pt.as[JsArray].value

    val doubleValues = arrValues.map {
      case JsString(s) => JsNumber(BigDecimal(s))
      case other => other
    }

    JsArray(doubleValues)
  }
}
