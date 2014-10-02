# Swarmize API access demo: using a backend

This demonstration uses a simple node.js backend to obfuscated the Swarm's API token, and also filter the fields being returned to the front-end. It illustrates how relatively simple a backend needs to be to do so, and also how processing/manipulation of data JSON can be offloaded to the backend.

## Installation

Assuming you have node already installed, from the application directory, run `npm install`. This will install all appropriate modules.

## Running

From the application directory:

	npm start
	
And then you'll be able to visit the map at:

	http://localhost:5000/?mapid=guardian.jl1hn9jp
	
	
##  Notes

If you'd like to see the returned JSON, you can do so at

	http://localhost:5000/data
	
Compare this to the data submitted to 'mapdemo-standalone' direct from the API to see how a straightforward backend can improve the relative security of your application based on the Swarmize API. Note how we've removed the `howYouVoteString` function from the front-end Javascript, and are doing all processing within node.