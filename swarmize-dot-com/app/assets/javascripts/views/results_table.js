var ResultsTable = Backbone.View.extend({
  initialize: function() {
    this.listenTo(this.model, 'change', this.render);
  },

  render: function() {
    var that = this;
    $("#results_table tbody tr").remove();
    $.each(this.model.get('rows'), function(i,item) {
      var $row = $('<tr>');
      $.each(that.model.get('fieldCodes'), function(j, code) {
        if(code == 'timestamp') {
          var rawTime = item[code];
          var formattedTime = formatTimestamp(parseTimestamp(rawTime));
          $row.append(
            $('<td>').text(formattedTime)
          );
        } else {
          $row.append(
            $('<td>').text(item[code])
          );
        }
      });
      $("#results_table tbody").append($row);
    });
    $("span.huge-number").text(this.model.get('count'));
  }
});

