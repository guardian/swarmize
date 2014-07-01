var express = require('express');
var sentiment = require('sentiment');
var app = express();

app.get("/sentiment", function(req,res) {
  res.json(sentiment(req.query.input));
});

var port = Number(process.env.PORT || 5000);

var server = app.listen(port, function() {
  console.log("Sentiment analysis running on port " + port);
});
