var FieldWorkspace = {
  onDragEnterWorkspace: function(event) {
    event.preventDefault();
    FieldWorkspace.updateDragCount(event);
  },

  onDragOverWorkspace: function(event) {
    var type = window.beingDraggedType;
    var text = window.beingDraggedText;
    var index = FieldWorkspace.getIndexForEvent(event);

    var tempElement = '<div class="form-element temp">' + text + '</div>';

    if(window.currentDropIndex && (index != window.currentDropIndex)) {
      console.log("currentDropIndex is " + window.currentDropIndex + " but actual index is " + index);
      $(".temp").remove();
    }
    window.currentDropIndex = index;
    
    if($(".temp").length < 1) {
      if($(".form-element").length > 0) {
        if(index == 0) {
          $(".form-element:eq(0)").before(tempElement);
        } else {
          $(".form-element:eq(" + (index-1) + ")").after(tempElement);
        }
      } else {
        $("#workspace form").append(tempElement);
      }
    }
    $("#workspace").addClass('hover');
    event.preventDefault(); 
  },

  onDragLeaveWorkspace: function(event) {
    $("#workspace").removeClass('hover')
    $(".temp").remove();
    FieldWorkspace.resetDragCount(event);
  },

  onDragEndWorkspace: function(event) {
    FieldWorkspace.resetDragCount(event);
    $(this).removeClass('hover');
  },

  onDropWorkspace: function(event) {
    var type = event.dataTransfer.getData('text/plain');
    var template = _.template( $('#' + type + '_template').html(), {} );
    $('.temp').remove();
    $('#workspace form').append(template);
    FieldWorkspace.bindLinks();
    FieldWorkspace.reindexFormElements();
    FieldWorkspace.resetDragCount(event);
    event.preventDefault();
  },

  getIndexForEvent: function(event) {
    var middles = _.map($(".form-element"), function(o) { 
      var top = $(o).offset().top;
      var mid = top + ($(o).height() / 2);
      return mid;
    });

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
  },

  updateDragCount: function(event) {
    var $hierarchy = $(event.target).parents().add(event.target),
    $workspace = $hierarchy.filter('#workspace'),
    countOffset = event.type === 'dragenter' ? 1 : -1;

    var dragCount = ($('#workspace').data('dragCount') || 0) + countOffset;
    $('#workspace')
      .data('dragCount', dragCount)
      .toggleClass('dragging', dragCount > 0);

    //console.log("Dragcount: " + dragCount);
  },

  resetDragCount: function(event) {
    $('#workspace')
      .data('dragCount', 0)
      .removeClass('dragging');

    //console.log("Dragcount: " + 0);
  }

}
