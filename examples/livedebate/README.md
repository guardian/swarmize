# Swarmize app demo: using a backend

This demonstration is of a "live clicker" for real-time feedback during a TV debate: the user enters their name and postcode, and then taps a face every time they agree with something said on TV.

## Installation

This app is a small Ruby/Sinatra application.

Assuming you have Ruby already installed, from the application directory, run `bundle install`. This will install all appropriate gems.

## Running

From the application directory:

	bundle exec rackup
	
And then you'll be able to visit the clicker at:

	http://localhost:9292
	
	
##  Notes

You'll note you don't need an API key to send data to the Collector API: all valid requests to swarms that aren't closed are accepted; you just need to know the field names, swarm token, and ensure your data submitted is valid.

So as to be able to filter all results by individual users, each user gets a unique token which is set as a cookie, and injected into their submission to the collector API. Using the backend code, it'd also be possible to inject other data into the request, if you need to.

The app is presented as a single form for conceptual purposes - one form posting to Swarmize - but could, obviously, be made more complex to make the interactions more compelling.

As you can see, unlike the retrieval API examples, submitting to the Collector is most straightforwardly done without a backend, and there are few downsides to this approach.