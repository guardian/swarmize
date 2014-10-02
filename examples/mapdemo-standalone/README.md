# Swarmize API access demo: standalone access

This demonstration shows how simple access to the Swarmize API can be. Because we have no cross-origin protection, you can simply make requests directly from a front-end.

## Running

Serve "index.html" from a webserver of your choice. For instance, in the project directory:

	python -m SimpleHTTPServer
	
or using node's `http-server`

	http-server

From the application directory:

	npm start
	
And then you'll be able to visit the map at:

	http://localhost:8000/?mapid=guardian.jl1hn9jp
	
(or whatever port the server is running on).

## Notes
	
If you'd like to see the returned JSON, you can do so at

	http://api.swarmize.com/swarms/rycadjgp/entirety?format=geojson&geo_json_point_key=what_s_your_postcode_lonlat&api_token=663e3710c9081919

As you can see, *all* fields from the Swarm are returned in full - and your API token is exposed in public. This may not be an issue depending on your dataset, but the deliberate insecurity of this should be encouragement to use a straightforward backend where appropraite.
