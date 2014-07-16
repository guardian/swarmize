var FieldWorkspace = {
  onDragOverWorkspace: function(event) {
    console.log('Dragged over workspace');
    var type = window.beingDraggedType;
    var text = window.beingDraggedText;
    var index = FieldWorkspace.getIndexForEvent(event);
    var newElement = '<div class="form-element temp">' + text + '</div>';
    var tempOuterHtml = $('.temp').clone().wrap('<p>').parent().html();
    if(tempOuterHtml != newElement) {
      console.log("Oh, this element is different.");
      console.log(tempOuterHtml);
      console.log(newElement);
      $(".temp").remove();
      if($('.form-element').length > 0) {
        if(index == 0) {
          $(".form-element:eq(0)").before(newElement);
        } else {
          $(".form-element:eq(" + (index-1) + ")").after(newElement);
        }
      } else {
        $("#workspace form").append(newElement);
      }
    }
    $("#workspace").addClass('hover');
    event.preventDefault(); 
  },

  onDragLeaveWorkspace: function(event) {
    console.log('Drag left workspace');
    $("#workspace").removeClass('hover')
    $(".temp").remove();
  },

  onDragEndWorkspace: function(event) {
    $(this).removeClass('hover');
  },

  onDropWorkspace: function(event) {
    index = FieldWorkspace.getIndexForEvent(event);
    var type = event.dataTransfer.getData('text/plain');
    var template = _.template( $('#' + type + '_template').html(), {} );
    $('.temp').remove();
    if($('.form-element').length > 0) {
      $('.form-element:eq(' + (index-1) + ")").after(template);
    } else {
      $('#workspace form').append(template);
    }
    FieldWorkspace.bindLinks();
    FieldWorkspace.reindexFormElements();
    event.preventDefault();
  },

  getIndexForEvent: function(event) {
    var middles = _.map($(".form-element"), function(o) { 
      var top = $(o).offset().top;
      var mid = top + ($(o).height() / 2);
      return mid;
    });
    var data = event.dataTransfer.getData("text/plain");

    var index = 0;
    _.each(middles, function(t) {
      if(event.clientY > t) {
        index++;
      }
    });
    return index;
  },

  bindLinks: function() {
    $("#workspace form a.close-this-element").unbind();
    $("#workspace form a.close-this-element").click(function(e) {
      $(this).parents(".form-element").remove();
      FieldWorkspace.reindexFormElements();
      return false;
    });
  },

  reindexFormElements: function() {
    $("#workspace .form-element").each(function(i, el) {
      $(el).find("input[name=index]").val(i);
    });
  }




}
