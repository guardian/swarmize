var PaletteField = {
  setupDraggable: function() {
    $('.fields-palette .field').attr('draggable', 'true');
    $('.fields-palette .field').attr('ondragstart', 'PaletteField.onDragPaletteStart(event)');
    $('.fields-palette .field').attr('ondragend', 'PaletteField.onDragPaletteEnd(event)');
  }, 

  onDragPaletteStart: function(event) {
    var type = $(event.toElement).attr('id').replace("_dragger", "");
    var text = $(event.toElement).text();

    event.dataTransfer.setData('text/plain', type);
    window.beingDraggedType = type;
    window.beingDraggedText = text;
  },

  onDragPaletteEnd: function(event) {
    $('.hover').removeClass('hover');
    window.beingDraggedType = null;
    window.beingDraggedText = null;
  }
}

