#!/bin/sh

curl -v -XPOST "http://localhost:9000/swarms/hwuxlrfh" \
    -d user_key=12345 \
    -d timestamp=$(date +%s) \
    -d intent=green \
    -d feedback="Mr King" \
    -d postcode="N1 9GU" \
    -d ip="10.0.0.1"
