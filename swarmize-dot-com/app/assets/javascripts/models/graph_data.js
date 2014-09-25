var GraphData = Backbone.Model.extend({
  fetch: function() {
    var that = this;
    $.ajax({
      type: 'GET',
      url: this.get('url'),
      success: function(data) {
        that.set('data', data);
        that.trigger('data-update');
      }
    });
  }
});
