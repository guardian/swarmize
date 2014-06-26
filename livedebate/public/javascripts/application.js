$(document).ready(function() {

	// Open external links in a new window
  $(".feedback-buttons").hide();

  $(".next-button").click(function(e) {
    $(".setup").hide();
    $("h1").hide();
    $(".feedback-buttons").show();
    e.preventDefault();
  });

  $(".feedback-button").click(function(e) {
    if(!$(this).hasClass('disabled')) {
      fadeOutLinks();
      $("input#feedback").val(this.id);
      $.post( $("form#debate").attr('action'),
             $("form#debate").serialize());
    }
    e.preventDefault();
  });

});

function fadeOutLinks() {
  $(".feedback-button").animate({'opacity': 0.3},500);
  $(".feedback-button").addClass('disabled');
  setTimeout(fadeUpLinks, 3000);
}

function fadeUpLinks() {
  $(".feedback-button").animate({'opacity': 1},500);
  $(".feedback-button").fadeTo(1);
  $(".feedback-button").removeClass('disabled');
}
