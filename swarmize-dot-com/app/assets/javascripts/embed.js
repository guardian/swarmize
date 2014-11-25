//= require jquery
//= require jquery.iecors
//= require underscore-min
//= require parsley-config
//= require parsley.min

function emitHeight() {
  // get the height of this, and send it to the parent 
  var thisHeight = $(".container").height();

  // pipe-delimted data:
  // yes, it's horrid but it's IE8/9 compatible.
  parent.postMessage('swarmizeSetHeight|'+thisHeight, '*');
}

$(document).ready(function() {
  emitHeight();

  $.listen('parsley:form:validated', function() {
    emitHeight();
  });

  $(".embeddable-swarm form").on( "submit", function( event ) {
    var form = this;
    event.preventDefault();

    $.ajax({
      url: $(form).attr('action'),
      data: $(form).serialize(),
      type: 'POST'
    }).done(function(data) {
      $(".embeddable-swarm form").remove();

      var resultDiv = $("<div>");
      resultDiv.addClass('result').addClass('success');
      resultDiv.text("Thank you for your submission.");
      $(".embeddable-swarm .feedback").append(resultDiv);

      emitHeight();
      parent.postMessage('swarmizeFormSuccess', '*'); 
    }).fail(function(data) {
      $("div.failure").remove();

      var resultDiv = $("<div>");
      resultDiv.addClass('result').addClass('failure');
      resultDiv.text("We're sorry: there was an error, and your results could not be submitted.");
      $(".embeddable-swarm form p.submit").prepend(resultDiv);

      emitHeight();
    });
  });
});
