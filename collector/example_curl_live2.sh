#!/bin/sh

curl -XPOST "http://collector.swarmize.com/swarms/cpvywzme.json" -d @- <<EOF
{
"do_you_like_swarmize": "yes",
"do_you_think_you_ll_use_swarmize": "yes",
"any_other_comments": "automated curl at $(date)",
"which_days_of_the_week_are_you_likely_to_use_swarmize": "wednesday",
"what_is_your_postcode": "N1 9GU"
}
EOF