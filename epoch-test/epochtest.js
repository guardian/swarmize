var express = require('express');
var app = express();
app.use(express.static(__dirname + '/public'));

app.get("/random_area", function(req,res) {
  var n1 = parseInt(Math.random() * 100) + 50;
  var n2 = parseInt(Math.random() * 100) + 50;
  var ts = ((new Date()).getTime() / 1000)|0;

  var responseObject = [ts,n1,n2];
  var dataPoint = [
    {time: ts,
      y: n1
    },
    {time: ts,
      y: n2
    }
  ];
  res.json(dataPoint);
});

app.get("/random_gauge", function(req,res) {
  var value = Math.random();
  res.json(value);
});

app.get("/initial_data", function(req,res) {
  var entries = 10;
  var layers = 2;
  var history = [];
  for (var k = 0; k < layers; k++) {
    history.push({ values: [] });
  }

  var ts = ((new Date()).getTime() / 1000)|0;

  for (var i = 0; i < entries; i++) {
    for (var j = 0; j < layers; j++) {
      history[j].values.push({time: ts, y: (parseInt(Math.random() * 100) + 50)});
    }
    ts++; 
  }

  res.json(history);
});

var server = app.listen(3000, function() {
  console.log("App listening on port 3000");
});
