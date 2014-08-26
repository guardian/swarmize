External Processors
===================

Example for postcode field
--------------------------

Where a field is of type "postcode", the swamrize processor will invoke an external url:

    POST http://somehost/process?field=what_is_your_postcode
    Content-Type: application/json

    {
      "do_you_like_swarmize" : true,
      "do_you_think_you_ll_use_swarmize" : true,
      "any_other_comments" : "automated curl at Tue 26 Aug 2014 14:35:41 BST",
      "which_days_of_the_week_are_you_likely_to_use_swarmize" : [ "wednesday" ],
      "what_is_your_postcode": "SW19",
      "timestamp" : "2014-08-26T13:35:40.712Z"
    }
    
    
The field parameter says which field to process. There may be multiple field parameters if there is more than one postcode field to process. 

It expects a response back:

    200 OK
    Content-Type: application/json
    
    {
      "do_you_like_swarmize" : true,
      "do_you_think_you_ll_use_swarmize" : true,
      "any_other_comments" : "automated curl at Tue 26 Aug 2014 14:35:41 BST",
      "which_days_of_the_week_are_you_likely_to_use_swarmize" : [ "wednesday" ],
      "what_is_your_postcode": "SW19",
      "what_is_your_postcode_lonlat": [ 0.012, -1.2 ],
      "what_is_your_postcode_mp": "Some Guy",

      "timestamp" : "2014-08-26T13:35:40.712Z"
    }
    
The response body is interpreted as the new submission in the pipeline.

You can also respond:

    204 No content
   
Which is a success and no modification will be made to the submission.

Any other response is treated as an error.



  