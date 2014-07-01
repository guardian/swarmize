var express = require('express');
var request = require('request');
var app = express();

app.get("/geocode", function(req,res) {
  console.log(req);

  request('http://open.mapquestapi.com/nominatim/v1/search.php?format=json&limit=5&q='+req.query.input, function (error, response, body) {
    if (!error && response.statusCode == 200) {
      var json = JSON.parse(body);
      res.json(json);
    }
  })
});

var port = Number(process.env.PORT || 5000);

var server = app.listen(port, function() {
  console.log("Geocoder running on port " + port);
});
