var SwarmizeTimeSeriesGraph = Backbone.View.extend({
  initialize: function() {
    this.listenTo(this.model, 'change', this.render);

    // set up the contianers for the timeseries
    $("#graphs").append("<div class='graph-container' id='graph-container" + this.model.get('index') + "'></div>");
    // create the title
    $("#graph-container" + this.model.get('index') + "").append("<h3>" + this.model.get('title') + "</h3>");
  },

  render: function() {
    console.log('rendering timeseries for data ', this.model.get('data'));
    var that = this;

    // clear out the old legend
    $("#graph-container" + that.model.get('index') + " .timeseries-legend").remove();
    // clear out the old timeseries
    $("#graph-container" + that.model.get('index') + " .timeseries-container").remove();

    // create the timeseries container
    $("#graph-container" + that.model.get('index') + "").append("<div class='timeseries-container' id='graph" + that.model.get('index') + "'></div>");
    // create the timeseries and axis inside the container
    $("#graph" + that.model.get('index') + "").append("<div class='timeseries'></div>");
    $("#graph" + that.model.get('index') + "").append("<div class='y_axis'></div>");
    // create the legend
    $("#graph-container" + that.model.get('index') + "").append("<div class='timeseries-legend'></div>");


    var palette = new Rickshaw.Color.Palette();

    var transformedData = _.map(that.model.get('data'), function(field) {
      field.color = palette.color();
      return field;
    });

    var graph = new Rickshaw.Graph( {
      element: document.querySelector('#graph' + that.model.get('index') + ' .timeseries'),
      width: 800,
      height: 300,
      renderer: 'line',
      series: transformedData,
      interpolation: 'linear'
    });

    var x_axis = new Rickshaw.Graph.Axis.Time( {graph: graph});
    var y_axis = new Rickshaw.Graph.Axis.Y({
      graph: graph,
      orientation: 'left',
      tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
      element: document.querySelector("#graph" + that.model.get('index') + " .y_axis")
    });

    var legend = new Rickshaw.Graph.Legend( {
      element: document.querySelector("#graph-container" + that.model.get('index') + " .timeseries-legend"),
      graph: graph
    });

    var hoverDetail = new Rickshaw.Graph.HoverDetail( {
      graph: graph,
      formatter: function(series, x, y) {
        var swatch = '<span class="detail_swatch" style="background-color: ' + series.color + '"></span>';
        var content = swatch + series.name;
        return content;
      }
    });

    graph.render();
  }
});
