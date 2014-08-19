#!/bin/sh

curl -XPOST "http://localhost:9000/swarms/cpvywzme.json" -d @- <<EOF
{"do_you_like_swarmize":"maybe","timestamp":$(date +%s),"intent":"green","feedback": "Mr King","postcode":"N1 9GU","ip":"10.0.0.1"}
EOF
