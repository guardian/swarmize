var express = require('express');
var request = require('request');
var querystring = require('querystring');

var app = express();

app.use(express.static(__dirname + '/public'));

// the API Key is, effectively, a global.
var apiKey = '35c58cae15301cfa';

app.get("/data/:method", function(req,res) {
  // take the original query and merge in the API Token
  var query = req.query
  query.api_key = apiKey;

  // hit the requested method on the Swarmize API with the new querystring...
  var newQueryString = 'http://api.swarmize.com/swarms/rycadjgp/' + req.params.method + "?" + querystring.stringify(query);
  request(newQueryString, function (error, response, body) {
    if (!error && response.statusCode == 200) {
      //... and return that JSON straight to the browser
      var json = JSON.parse(body);
      res.json(json);
    }
  })
});

var port = Number(process.env.PORT || 5000);

var server = app.listen(port, function() {
  console.log("Generic swarmize retrieval backend running on port " + port);
});
