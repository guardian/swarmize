var express = require('express');
var sentiment = require('sentiment');
var app = express();

app.get("/sentiment", function(req,res) {
  res.json(sentiment(req.query.input));
});

var server = app.listen(3000, function() {
  console.log("Sentiment analysis running on port 3000");
});
