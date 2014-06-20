#!/bin/sh

curl -XPOST "http://localhost:9000/swarm/voting" -d '
{"user_key":12345,"timestamp":56789,"intent":"green","feedback": "Mr King","postcode":"N1 9GU","ip":"10.0.0.1"}
'