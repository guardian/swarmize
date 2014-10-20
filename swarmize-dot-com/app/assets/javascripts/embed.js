//= require jquery
//= require underscore-min
//= require parsley-config
//= require parsley.min

//var messageOrigin = window.location.protocol + "//" + window.location.host;
var messageOrigin = 'http://cdn.swarmize.com';

function emitHeight() {
  // get the height of this, and send it to the parent + 300 or something.
  var thisHeight = $(".container").height();

  parent.postMessage('setHeight|'+thisHeight, messageOrigin);
}

$(document).ready(function() {
  emitHeight();

  $.listen('parsley:form:validated', function() {
    emitHeight();
  });

  $( "form" ).on( "submit", function( event ) {
    var form = this;
    event.preventDefault();
    console.log( $( this ).serialize() );
    console.log( $( this ).attr('action'));
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
      parent.postMessage('formsuccess', messageOrigin); 
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
