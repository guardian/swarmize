#!/bin/sh

curl -XPOST "http://collector.swarmize.com/swarms/hwuxlrfh.json" -d @- <<EOF
{
"do_you_have_internet_at_home": "no",
"can_you_get_broadband_where_you_live": "no",
"who_is_your_broadband_provider": "bt",
"what_speed_does_your_broadband_provider_claim_you_are_getting": "up_to_2_megabits",
"what_is_your_actual_tested_broadband_speed": "6",
"what_is_your_postcode": "SW19",
"are_government_targets_enough_to_make_britain_a_world_leading_internet_economy": "not_sure",
"should_the_government_invest_more_in_broadband": "not_sure",
"anything_else_add_your_comments_here": "Bananas",
"your_details": "pa@x.com"
}
EOF