# Swarmize API

Swarmize's API is a read-only, HTTP-based API that returns JSON. It requires no extra tokens or authentication: knowing a Swarm's token is (currently) enough credentials to request data from it.

It currently lives at `http://api.swarmize.com`.

## Authentication

All Swarmize API calls require an **API Token** to be passed to the API via the query string.

API Tokens exist on a *per-swarm* basis. To create an API Token for a swarm, you'll need to have permission to edit it. You'll then be able to create one via the top-right dropdown on a Swarm, choosing "API Tokens", and creating a token to use.

An API Token can be revoked at any point, and doing so will make any code dependent on it fail.

## API Usage Advice

The API endpoint is open to Cross-Origin Requests. As such, you can make requests directly to the API from in-page Javascript on your site.

**HOWEVER:** note that by doing so, you effectively allow anyone else to do so as well. You'll expose your API token to the world, and given that the names of fields/questions in Swarmize are effectively public knowledge, you should assume that anyone can thus enumerate over the swarm.

This might not be an issue: many swarms are statistical and entirely anonymous. But if you've got qualitative text fields that might contain personal data, you almost certainly shouldn't make in-page Javascript calls to the API. Instead, it is recommended you behave as if CORS was disabled: make requests from your front-end to a back-end that you've written yourself, and make calls to the API from your server-side code. This way, your token will be hidden from public view.

## Endpoints

### Results (paginated)

`http://api.swarmize.com/swarms/rycadjgp/results?api_token=XXXX`

returns:

	{
	  "results": [
	    {
	      "what_s_your_postcode_lonlat": [
	        "0.782045248610257",
	        "51.19971135"
	      ],
	      "timestamp": "2014-09-08T15:06:54.842Z",
	      "unique_user_key": "1251",
	      "who_did_you_just_agree_with": "david_cameron",
	      "how_do_you_plan_to_vote_at_the_next_general_election": "conservative",
	      "what_s_your_postcode": "CH7"
	    },
	    {
	      "what_s_your_postcode_lonlat": [
	        "-2.23205806666667",
	        "55.6882913"
	      ],
	      "timestamp": "2014-09-08T15:06:53.011Z",
	      "unique_user_key": "2168",
	      "who_did_you_just_agree_with": "nick_clegg",
	      "how_do_you_plan_to_vote_at_the_next_general_election": "liberal_democrat",
	      "what_s_your_postcode": "TD12"
	    },
	    {
	      "what_s_your_postcode_lonlat": [
	        "3.14606690591304",
	        "50.6083506"
	      ],
	      "timestamp": "2014-09-08T15:06:52.881Z",
	      "unique_user_key": "1178",
	      "who_did_you_just_agree_with": "ed_miliband",
	      "how_do_you_plan_to_vote_at_the_next_general_election": "liberal_democrat",
	      "what_s_your_postcode": "SN5"
	    },
	    {
	      "timestamp": "2014-09-08T15:06:52.758Z",
	      "unique_user_key": "6557",
	      "who_did_you_just_agree_with": "ed_miliband",
	      "how_do_you_plan_to_vote_at_the_next_general_election": "liberal_democrat",
	      "what_s_your_postcode": "LL71"
	    },
	    {
	      "what_s_your_postcode_lonlat": [
	        "-2.33034637629688",
	        "52.1125993"
	      ],
	      "timestamp": "2014-09-08T15:06:52.623Z",
	      "unique_user_key": "1734",
	      "who_did_you_just_agree_with": "ed_miliband",
	      "how_do_you_plan_to_vote_at_the_next_general_election": "ukip",
	      "what_s_your_postcode": "WR15"
	    },
	    {
	      "what_s_your_postcode_lonlat": [
	        "-1.9969754176623",
	        "52.5146870572888"
	      ],
	      "timestamp": "2014-09-08T15:06:52.483Z",
	      "unique_user_key": "4802",
	      "who_did_you_just_agree_with": "nick_clegg",
	      "how_do_you_plan_to_vote_at_the_next_general_election": "green",
	      "what_s_your_postcode": "B70"
	    },
	    {
	      "what_s_your_postcode_lonlat": [
	        "-3.7839569",
	        "40.3836531"
	      ],
	      "timestamp": "2014-09-08T15:06:48.968Z",
	      "unique_user_key": "8800",
	      "who_did_you_just_agree_with": "nick_clegg",
	      "how_do_you_plan_to_vote_at_the_next_general_election": "conservative",
	      "what_s_your_postcode": "L10"
	    },
	    {
	      "what_s_your_postcode_lonlat": [
	        "27.5483523",
	        "47.1664926"
	      ],
	      "timestamp": "2014-09-08T15:06:48.731Z",
	      "unique_user_key": "2323",
	      "who_did_you_just_agree_with": "david_cameron",
	      "how_do_you_plan_to_vote_at_the_next_general_election": "other",
	      "what_s_your_postcode": "DD4"
	    },
	    {
	      "timestamp": "2014-09-08T15:06:48.590Z",
	      "unique_user_key": "7648",
	      "who_did_you_just_agree_with": "nick_clegg",
	      "how_do_you_plan_to_vote_at_the_next_general_election": "other",
	      "what_s_your_postcode": "IV41"
	    },
	    {
	      "what_s_your_postcode_lonlat": [
	        "103.7972287",
	        "1.3305875"
	      ],
	      "timestamp": "2014-09-08T15:06:48.451Z",
	      "unique_user_key": "745",
	      "who_did_you_just_agree_with": "david_cameron",
	      "how_do_you_plan_to_vote_at_the_next_general_election": "conservative",
	      "what_s_your_postcode": "DT7"
	    }
	  ],
	  "query_details": {
	    "total_pages": 522,
	    "page": 1,
	    "per_page": 10
	  }
	}

The responses is separated into a `results` object and a `query_details` object. The `query_details` object also returns how many pages of results there will be at the current per_page setting. It's possible to one or both of these via the query string:

`http://api.swarmize.com/swarms/rycadjgp/results?api_token=XXXX&per_page=50&page=3`

The default is `page=1&per_page=10`.

### Results (all)

The `#entirety` endpoint will return the entire dataset. *Warning:* this could be really, really big. And slow.

`http://api.swarmize.com/swarms/rycadjgp/entirety?api_token=XXXX`

Note that there is no `query_details` object: just a single array representing all the objects in the search.

#### Results (all) as GeoJSON

It's possible to specify a GeoJSON format for the big-bucket-of-results. To do so requires passing two details into the query string: the fact you want GeoJSON results, and the field you wish to use as the latlon field for points. (There may be several latlon objects in a Swarm, hence specifying them is important).

For instance:

`http://api.swarmize.com/swarms/rycadjgp/entirety?api_token=XXXX&format=geojson&geo_json_point_key=what_s_your_postcode_lonlat`

returns
	
	{
	  "type": "FeatureCollection"
	  "features": [
	    {
	      "properties": {
	        "timestamp": "2014-09-08T12:04:51.337Z",
	        "unique_user_key": "6651",
	        "who_did_you_just_agree_with": "ed_miliband",
	        "how_do_you_plan_to_vote_at_the_next_general_election": "conservative",
	        "what_s_your_postcode": "BS15"
	      },
	      "geometry": {
	        "coordinates": [
	          -2.510454,
	          51.4660509
	        ],
	        "type": "Point"
	      },
	      "type": "Feature"
	    },
	    {
	      "properties": {
	        "timestamp": "2014-09-08T12:04:51.796Z",
	        "unique_user_key": "7655",
	        "who_did_you_just_agree_with": "david_cameron",
	        "how_do_you_plan_to_vote_at_the_next_general_election": "liberal_democrat",
	        "what_s_your_postcode": "SK22"
	      },
	      "geometry": {
	        "coordinates": [
	          -1.9473631577878,
	          53.3812771896761
	        ],
	        "type": "Point"
	      },
	      "type": "Feature"
	    },
	    {
	      "properties": {
	        "timestamp": "2014-09-08T12:04:51.496Z",
	        "unique_user_key": "710",
	        "who_did_you_just_agree_with": "david_cameron",
	        "how_do_you_plan_to_vote_at_the_next_general_election": "liberal_democrat",
	        "what_s_your_postcode": "YO23"
	      },
	      "geometry": {
	        "coordinates": [
	          -1.10619142145065,
	          53.8995774889324
	        ],
	        "type": "Point"
	      },
	      "type": "Feature"
	    },
	    ...
	  ]
	}
