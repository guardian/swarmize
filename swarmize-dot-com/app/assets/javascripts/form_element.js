var FormElement = {
  onDragStart: function(event) {
    if($(event.toElement).find('.move-this-element').is(FormElement.dragTarget)) {
      console.log("Dragged by handle");
      FormElement.draggedElement = event.toElement;
      event.dataTransfer.effectAllowed = 'move';
      event.dataTransfer.dropEffect = 'move';
      event.dataTransfer.setData('text/plain', 'formElement');

      window.beingDraggedType = 'formElement';
      window.beingDraggedText = "Move to here";
    } else {
      console.log("Dragged by other");
      event.preventDefault();
    }
  },

  setupDraggableFields: function() {
    FormElement.dragTarget = false;
    $(".form-element").attr('draggable', 'true');
    $(".form-element .move-this-element").on('mousedown', function(e) {
      FormElement.dragTarget = e.target;
    });
    $('.form-element').attr('ondragstart', 'FormElement.onDragStart(event)');
  }
}
