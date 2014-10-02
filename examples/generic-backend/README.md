# Swawrmize Retrieval API Generic Backend

If you've read the documentation, and looked at both the `mapdemo-standaone` and `mapdemo-backend`, you'll realise that having some kind of back-end for retrieving any remotely sensitive data from a Swarm is a good idea. 

Fortunately, it really doesn't have to be that complex: this is a sample node.js application that forwards requests to the Retreival API and merges the API token in on the backend. Both querystring and method are defined in the front-end JS; the back-end of the site simply adds the API token to the request.

## Installation

Assuming you have node already installed, from the application directory, run `npm install`. This will install all appropriate modules.

## Running

From the application directory:

	npm start
	
And then you'll be able to visit the sample index page at:

	http://localhost:5000/
	
## Notes

`backend.js` is the entirety of the backend code, and the comments within should explain what is happening.

`public/index.html` contains the Javascript making the AJAX call, and you can see how the method name (`results`) and parameters passed to the back-end are defined.