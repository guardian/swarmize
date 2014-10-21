# Swarmize Retrieval API - documentation

Swarmize's Retrieval API is a read-only, HTTP-based API that returns JSON. It requires an API Key generated on a per-swarm basis to access it. Keys can be revoked from the main Swarmize app at any time.

It currently lives at `http://api.swarmize.com`.

## Authentication

All Swarmize Retrieval API calls require an **API Key** to be passed to the API via the query string.

API keys exist on a *per-swarm* basis. To create an API Key for a swarm, you'll need to have permission to edit it. You'll then be able to create one via the top-right dropdown on a Swarm, choosing "API Keys", and creating a key to use.

An API Key can be revoked at any point, and doing so will make any code dependent on it fail.

## API Usage Advice

The Retrieval API endpoint is open to Cross-Origin Requests. As such, you can make requests directly to the Retrieval API from in-page Javascript on your site.

**HOWEVER:** note that by doing so, you effectively allow anyone else to do so as well. You'll expose your API key to the world, and given that the names of fields/questions in Swarmize are effectively public knowledge, you should assume that anyone can thus enumerate over the swarm.

This might not be an issue: many swarms are statistical and entirely anonymous. But if you've got qualitative text fields that might contain personal data, you almost certainly shouldn't make in-page Javascript calls to the Retrieval API. Instead, it is recommended you behave as if CORS was disabled: make requests from your front-end to a back-end that you've written yourself, and make calls to the Retrieval API from your server-side code. This way, your key will be hidden from public view.

There are two examples in the `/examples` directory that should make this clear. 

* `mapdemo-standalone` is a series of points plotted on a map from a Swarm, directly accessing the Retrieval API. The API key is exposed publicly, and all fields are returned from the swarm.
* `mapdemo-backend` uses a tiny node.js backend to filter the fields returned to the front-end, and obfuscate the API key.

## Endpoints

### Swarm description

`http://api.swarmize.com/swarms/rycadjgp?api_key=XXXX`

returns a programmatic description of the swarm:

	{
	  "closes_at": "2014-08-29T13:42:42.697Z",
	  "opens_at": "2014-08-29T13:41:38.113Z",
	  "fields": [
	    {
	      "compulsory": true,
	      "field_name_code": "do_you_like_swarmize",
	      "field_name": "Do you like swarmize?",
	      "field_type": "yesno"
	    },
	    {
	      "compulsory": true,
	      "field_name_code": "do_you_think_you_ll_use_swarmize",
	      "field_name": "Do you think you'll use swarmize?",
	      "field_type": "yesno"
	    },
	    {
	      "compulsory": false,
	      "field_name_code": "any_other_comments",
	      "field_name": "Any other comments?",
	      "field_type": "bigtext"
	    },
	    {
	      "possible_values": {
	        "friday": "Friday",
	        "wednesday": "Wednesday",
	        "monday": "Monday"
	      },
	      "compulsory": false,
	      "field_name_code": "which_days_of_the_week_are_you_likely_to_use_swarmize",
	      "field_name": "Which days of the week are you likely to use swarmize?",
	      "field_type": "pick_several"
	    },
	    {
	      "compulsory": true,
	      "field_name_code": "what_is_your_postcode",
	      "field_name": "What is your postcode?",
	      "field_type": "postcode"
	    }
	  ],
	  "description": "Simple feedback form for swarmize ",
	  "name": "Do you like swarmize?"
	}




### Result counts

`http://api.swarmize.com/swarms/rycadjgp/counts?api_key=XXXX`

returns:

	[
	  {
	    "counts": [
	      {
	        "false": 14
	      },
	      {
	        "true": 13
	      },
	      {
	        "maybe": 1
	      }
	    ],
	    "compulsory": true,
	    "field_name_code": "do_you_like_swarmize",
	    "field_name": "Do you like swarmize?",
	    "field_type": "yesno"
	  },
	  {
	    "counts": [
	      {
	        "true": 26
	      },
	      {
	        "false": 1
	      }
	    ],
	    "compulsory": true,
	    "field_name_code": "do_you_think_you_ll_use_swarmize",
	    "field_name": "Do you think you'll use swarmize?",
	    "field_type": "yesno"
	  },
	  {
	    "counts": [
	      {
	        "wednesday": 11
	      },
	      {
	        "friday": 2
	      },
	      {
	        "monday": 1
	      }
	    ],
	    "possible_values": {
	      "friday": "Friday",
	      "wednesday": "Wednesday",
	      "monday": "Monday"
	    },
	    "compulsory": false,
	    "field_name_code": "which_days_of_the_week_are_you_likely_to_use_swarmize",
	    "field_name": "Which days of the week are you likely to use swarmize?",
	    "field_type": "pick_several"
	  }
	]
	
Result counts are only returned for the following field types: `pick_one`, `pick_several`, `rating`, `yesno` `check_box`. Field of other types will not be listed at this endpoint.

The `counts` object will list the number of rows in the whole swarm where this field has a particular value. 


### Results (paginated)

`http://api.swarmize.com/swarms/rycadjgp/results?api_key=XXXX`

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

`http://api.swarmize.com/swarms/rycadjgp/results?api_key=XXXX&per_page=50&page=3`

The default is `page=1&per_page=10`.

By default, results are sorted chronologically. You can specify ordering with the `order_by` query parameter, eg:

`http://api.swarmize.com/swarms/rycadjgp/results?api_key=XXXX&per_page=50&page=3&order_by=newest`


#### Results (paginated) as GeoJSON

It's possible to specify a GeoJSON format for the paged resuls. To do so requires passing two details into the query string: the fact you want GeoJSON results, and the field you wish to use as the latlon field for points. (There may be several latlon objects in a Swarm, hence specifying them is important).

You'll probably want to specify a large "per_page" parameter when you call this. Set this to the largest size that your mapping tool can deal with, typically values around 5000 are reasonable.


For instance:

`http://api.swarmize.com/swarms/rycadjgp/results?api_key=XXXX&per_page=5000&format=geojson&geo_json_point_key=what_s_your_postcode_lonlat`

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


### Latest result

	http://api.swarmize.com/swarms/rycadjgp/latest?api_key=XXXX

will return the JSON for the most recent result. For instance:

	{
	  "what_s_your_postcode_lonlat": [
	    -2.11886756,
	    57.08312836
	  ],
	  "timestamp": "2014-10-01T10:45:02.153Z",
	  "unique_user_key": "1411481620126",
	  "who_did_you_just_agree_with": "alistair_darling",
	  "do_you_think_scotland_should_be_an_independent_country": true,
	  "what_s_your_postcode": "AB12"
	}

One use case for this might be building a Twitter scraper: every time you query Twitter, you need to know what the startpoint for your query should be; asking for the most recently stored tweet would let you tell Twitter where to start its search.

