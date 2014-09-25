var SwarmizePieGraph = Backbone.View.extend({
  initialize: function() {
    this.listenTo(this.model, 'change', this.render);

    // set up some stuff on the screen
    var containerSelector = "#graph-container" + this.model.get('index');
    $("#graphs").append("<div class='graph-container' id='graph-container" + this.model.get('index') + "'></div>");
    $(containerSelector).append("<h3>" + this.model.get('title') + "</h3>");
    $(containerSelector).append("<div class='g' id='graph" + this.model.get('index') + "'></div>");

  },

  render: function() {
    console.log('rendering chart');
    var that = this;
    if(this.chart) {
      console.log('updating chart');
      this.chart.load({
        json: that.model.get('data')
      });
    } else {
      console.log('creating chart');
      var that = this
      this.chart = c3.generate({
        bindto: '#graph'+that.model.get('index'),
        data: {
          json: that.model.get('data'),
          type: 'pie'
        }
      });
    }
  }
});
