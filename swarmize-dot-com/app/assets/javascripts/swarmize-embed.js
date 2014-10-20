// this is the js to embed in a page
// it must assume NO JQUERY

// when we're good to go
window.onload = function() {
  // find the div
  var embedDiv = document.getElementById('swarmize-embedded-form');

  var token = embedDiv.dataset.swarmizeToken;

  // insert an iFrame
  embedDiv.innerHTML = "<iframe src='http://cdn.swarmize.com/swarms/"+token+"/embed' width='460' height='400' frameBorder='0' seamless='seamless'></iframe>";

  var iframe = embedDiv.getElementsByTagName('iframe')[0];
  
  respondToMessage = function(e) {
    var chunks = e.data.split("|");
    if(chunks[0] == 'setHeight') {
      var height = chunks[1];
      iframe.setAttribute('height', height);
    }

    if(chunks[0] == 'formsuccess') {
      window.scrollTo(0,iframe.offsetTop);
    }
  }
  // we have to listen for 'message'
  window.addEventListener('message', respondToMessage, false);
}
