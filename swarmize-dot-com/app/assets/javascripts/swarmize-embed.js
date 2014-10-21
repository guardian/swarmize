// This is the JS embedded in the page that will host the iFrame
// It assumes that there is no jQuery, just a modern browser.

// when we're good to go
window.onload = function() {
  // find the div
  var embedDiv = document.getElementById('swarmize-embedded-form');

  // extract token from data attribute
  var token = embedDiv.dataset.swarmizeToken;

  // insert an iFrame containing the embed
  if(window.location.hostname == 'alpha.swarmize.com') {
    var origin = window.location.origin;
  } else {
    var origin = 'http://cdn.swarmize.com';
  }
  embedDiv.innerHTML = "<iframe src='" + origin + "/swarms/"+token+"/embed' width='460' height='400' frameBorder='0' seamless='seamless'></iframe>";

  var iframe = embedDiv.getElementsByTagName('iframe')[0];

  iframe.style('width', '100%');
  
  respondToMessage = function(e) {
    var chunks = e.data.split("|");

    // when the form changes size, update the height of the iFrame
    if(chunks[0] == 'swarmizeSetHeight') {
      var height = chunks[1];
      iframe.setAttribute('height', height);
    }

    // when the form is submitted, scroll top the top of the iFrame
    if(chunks[0] == 'swarmizeFormSuccess') {
      window.scrollTo(0,iframe.offsetTop);
    }
  }

  // listen out for the message event.
  window.addEventListener('message', respondToMessage, false);
}
