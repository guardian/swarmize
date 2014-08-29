#!/bin/sh


curl -XPOST "http://collector.swarmize.com/swarms/moqxjfwr" \
    -d do_you_like_swarmize=yes \
    -d do_you_think_you_ll_use_swarmize=yes \
    -d any_other_comments="automated curl at $(date)" \
    -d which_days_of_the_week_are_you_likely_to_use_swarmize="wednesday" \
    -d which_days_of_the_week_are_you_likely_to_use_swarmize="monday" \
    -d what_is_your_postcode="N1 9GU"

