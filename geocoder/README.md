# Swarmize geocoder

This utility acts as the geocoding endpoint for the Swarmize processing pipeline. It uses the MapQuest Open API for geocoding.

## Installation

Assuming you have node already installed, from the application directory, run `npm install`. This will install all appropriate modules.

## Running

From the application directory:

	npm start
	
And then you'll be able to visit the sample index page at:

	http://localhost:5000/
	
## Notes

`geocoder` is the entirety of the tool. It receives data in and either returns a JSON object representing the lat/lon of the top match from Mapquest, or returns HTTP 204 (No Content) when nothing can be found.