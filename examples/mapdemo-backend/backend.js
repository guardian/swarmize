var express = require('express');
var request = require('request');
var _ = require('underscore');

var app = express();

app.use(express.static(__dirname + '/public'));

var lookupDict = {'conservative': 'Conservative',
                  'labour': 'Labour',
                  'liberal_democrat': 'Liberal Democrat',
                  'green': 'Green',
                  'ukip': 'UKIP',
                  'other': 'Labour'}

app.get("/data", function(req,res) {
  request('http://api.swarmize.com/swarms/rycadjgp/results?per_page=5000&format=geojson&geo_json_point_key=what_s_your_postcode_lonlat&api_key=35c58cae15301cfa', function (error, response, body) {
    if (!error && response.statusCode == 200) {
      // Filter the response to only return the fields we want to the front end
      var json = JSON.parse(body);
      json.features = _.map(json.features,function(feature) {
        feature.properties = _.pick(feature.properties, 'what_s_your_postcode', 'what_s_your_postcode_lonlat', 'how_do_you_plan_to_vote_at_the_next_general_election');

        // Let's map the codified string to something human readable on the
        // back-end, so we don't expose the swarm's field keys.
        feature.properties.how_do_you_plan_to_vote_at_the_next_general_election = lookupDict[feature.properties.how_do_you_plan_to_vote_at_the_next_general_election];
        return feature;
      });

      res.json(json);
    }
  })
});

var port = Number(process.env.PORT || 5000);

var server = app.listen(port, function() {
  console.log("Mapdemo backend running on port " + port);
});
