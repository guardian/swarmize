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
    console.log("Setting drop index to" + index);
    window.currentDropIndex = index;
    
    if($(".temp").length < 1) {
      if($(".form-element").length > 0) {
        if(index == 0) {
          $(".form-element:eq(0)").before(tempElement);
        } else {
          $(".form-element:eq(" + (index-1) + ")").after(tempElement);
        }
      } else {
        $("#workspace").append(tempElement);
      }
    }
    $("#workspace").addClass('hover');
    event.preventDefault(); 
  },

  onDragLeaveWorkspace: function(event) {
    if($("#workspace").data('dragCount') < 2) {
      $("#workspace").removeClass('hover')
      $(".temp").remove();
    }
    FieldWorkspace.updateDragCount(event);
  },

  onDragEndWorkspace: function(event) {
    FieldWorkspace.resetDragCount(event);
    $(this).removeClass('hover');
  },

  onDropWorkspace: function(event) {
    var type = event.dataTransfer.getData('text/plain');
    var template = _.template( $('#' + type + '_template').html(), {} );
    var index = FieldWorkspace.getIndexForEvent(event);

    $('.temp').remove();

    if($(".form-element").length > 0) {
      if(index == 0) {
        console.log("Appending before");
        $(".form-element:eq(0)").before(template);
      } else {
        $(".form-element:eq(" + (index-1) + ")").after(template);
      }
    } else {
      $("#workspace").append(template);
    }

    FieldWorkspace.bindLinks();
    FieldWorkspace.reindexFormElements();
    FieldWorkspace.resetDragCount(event);
    event.preventDefault();
  },

  getIndexForEvent: function(event) {
    var middles = _.map($(".form-element"), function(o) { 
      var top = $(o).offset().top;
      return top;
    });

    var index = 0;
    _.each(middles, function(t) {
      if(event.pageY > t) {
        index++;
      }
    });
    return index;
  },

  bindLinks: function() {
    $("#workspace a.close-this-element").unbind();
    $("#workspace a.close-this-element").click(function(e) {
      $(this).parents(".form-element").remove();
      FieldWorkspace.reindexFormElements();
      e.preventDefault();
    });


    $("#workspace .pick_one .add-option, #workspace .pick_several .add-option").unbind();
    $("#workspace .pick_one .add-option, #workspace .pick_several .add-option").click(function(e) {
      var newElement = "<p class='input-group'><input name='fields[]possible_values[]' class='form-control' /><span class='input-group-addon'><a href='#' class='remove-option'><span class='glyphicon glyphicon-remove'></span> </a></span></p>";
      $(this).parent().siblings('.option-list').append(newElement);
      FieldWorkspace.bindLinks();
      $(this).parent().siblings('.option-list').find('.form-control:last').focus()
      e.preventDefault();
    });

    $("#workspace .pick_one .remove-option, #workspace .pick_several .remove-option").unbind();
    $("#workspace .pick_one .remove-option, #workspace .pick_several .remove-option").click(function(e) {
      $(this).parents('p.input-group').remove();
      e.preventDefault();
    });
  },

  reindexFormElements: function() {
    $("#workspace .form-element").each(function(i, el) {
      $(el).find("input#index").val(i);
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
