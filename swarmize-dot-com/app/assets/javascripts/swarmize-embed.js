// This is the JS embedded in the page that will host the iFrame
// It assumes that there is no jQuery, just a modern browser.

// when we're good to go
window.onload = function() {
  // find the div
  var embedDiv = document.getElementById('swarmize-embedded-form');

  // extract token from data attribute
  var token = embedDiv.dataset.swarmizeToken;

  // insert an iFrame containing the embed
  embedDiv.innerHTML = "<iframe src='http://cdn.swarmize.com/swarms/"+token+"/embed' width='460' height='400' frameBorder='0' seamless='seamless'></iframe>";

  var iframe = embedDiv.getElementsByTagName('iframe')[0];
  
  respondToMessage = function(e) {
    var chunks = e.data.split("|");

    // when the form changes size, update the height of the iFrame
    if(chunks[0] == 'setHeight') {
      var height = chunks[1];
      iframe.setAttribute('height', height);
    }

    // when the form is submitted, scroll top the top of the iFrame
    if(chunks[0] == 'formsuccess') {
      window.scrollTo(0,iframe.offsetTop);
    }
  }

  // listen out for the message event.
  window.addEventListener('message', respondToMessage, false);
}
