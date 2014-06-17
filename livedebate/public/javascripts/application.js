$(document).ready(function() {

	// Open external links in a new window
	hostname = window.location.hostname
	$("a[href^=http]")
	  .not("a[href*='" + hostname + "']")
	  .addClass('link external')
	  .attr('target', '_blank');


  $(".feedback-buttons").hide();

  $(".next-button").click(function(e) {
    $(".setup").hide();
    $(".feedback-buttons").show();
    e.preventDefault();
  });

  $(".feedback-button").click(function(e) {
    $("input#feedback").val(this.id);
    $.post( $("form#debate").attr('action'),
           $("form#debate").serialize());
    e.preventDefault();
  });

});
