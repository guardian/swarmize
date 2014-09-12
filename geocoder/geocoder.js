var express = require('express');
var request = require('request');
var bodyParser = require('body-parser')

var app = express();

app.use(bodyParser.json())

app.post("/geocode", function(req,res) {

  var output = req.body;

  var fieldToGeocode = req.query.field;
  var valueToGeocode = req.body[fieldToGeocode];

  request('http://open.mapquestapi.com/nominatim/v1/search.php?format=json&limit=1&q='+valueToGeocode, function (error, response, body) {
    if (!error && response.statusCode == 200) {
      var json = JSON.parse(body);
      if(json.length > 0) {
        // we only care about the first one.
        var lat = json[0].lat;
        var lon = json[0].lon;
        
        var latLonFieldName = fieldToGeocode + "_lonlat";

        output[latLonFieldName] = [parseFloat(lon),parseFloat(lat)];

        res.json(output);
      } else {
        res.send(204);
      }
    }
  })
});

var port = Number(process.env.PORT || 5000);

var server = app.listen(port, function() {
  console.log("Geocoder running on port " + port);
});
