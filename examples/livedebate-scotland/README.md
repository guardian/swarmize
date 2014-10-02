# Swarmize app demo: single page example.

This demonstration is of a "live clicker" for real-time feedback during a TV debate: the user enters their name and postcode, and then taps a face every time they agree with something said on TV.

This demo differs from the original `livedebate` version by not requiring a backend: it posts data directly to the collector via Javascript.

## Running

Serve "index.html" from a webserver of your choice. For instance, in the project directory:

	python -m SimpleHTTPServer
	
or using node's `http-server`

	http-server

From the application directory:

	npm start
	
And then you'll be able to view the clicker at:

	http://localhost:8000/
		
(or whatever port the server is running on).
	
	
##  Notes

You'll note you don't need an API token to send data to the Collector API: all valid requests to swarms that aren't closed are accepted; you just need to know the field names, swarm token, and ensure your data submitted is valid.

So as to be able to filter all results by individual users, each user gets a unique token which is set as a cookie, and injected into a hidden field within the form.

The app is presented as a single form for conceptual purposes - one form posting to Swarmize - but could, obviously, be made more complex to make the interactions more compelling.

As you can see, unlike the retrieval API examples, submitting to the Collector is most straightforwardly done without a backend, and there are few downsides to this approach.