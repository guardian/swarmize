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
      clickVisuals(this);
      $("input#feedback").val(this.id);
      $.post( $("form#debate").attr('action'),
             $("form#debate").serialize());
    }
    e.preventDefault();
  });

});

function clickVisuals(el) {
  $(".feedback-button").animate({'opacity': 0.5},200);

  var top = $(el).offset().top + 20
  //var left = ($(el).width() / 2) - 20;
  var left = 0;

  $("body").append("<div class='tick'>&#10003;</div>")
  $(".tick").css('top', top+"px").css('left', left + 'px').fadeIn();

  $(".feedback-button").addClass('disabled');
  setTimeout(fadeUpLinks, 200);
}

function fadeUpLinks(el) {
  $(".tick").fadeOut(function() { $(this).remove(); } );
  $(".feedback-button").animate({'opacity': 1},200);
  $(".feedback-button").fadeTo(1);
  $(".feedback-button").removeClass('disabled');
}
