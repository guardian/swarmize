var express = require('express');
var request = require('request');
var app = express();

app.get("/geocode", function(req,res) {
  console.log(req);

  request('http://open.mapquestapi.com/nominatim/v1/search.php?format=json&limit=5&q='+req.query.address, function (error, response, body) {
    if (!error && response.statusCode == 200) {
      var json = JSON.parse(body);
      res.json(json);
    }
  })
});

var server = app.listen(3000, function() {
  console.log("Geocoder running on port 3000");
});
