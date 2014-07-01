#!/bin/sh

curl -XPOST "http://Swarmize-Collecto-TJM7GAWKNW0Z-2117267710.us-east-1.elb.amazonaws.com/swarm/voting" -d '
{"user_key":12345,"timestamp":56789,"intent":"green","feedback": "Mr Smith","postcode":"N1 9GU","ip":"10.0.0.1"}
'