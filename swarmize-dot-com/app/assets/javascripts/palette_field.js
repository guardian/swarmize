var PaletteField = {
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
