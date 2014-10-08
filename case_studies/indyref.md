# #indyref swarm

## Background

In the run up to the Scottish referendum, we decided to survey the mood of Twitter users tweeting about the referendum. Discussion around the referendum was focusing around the hashtag **#indyref**, and the hashtags **#voteyes** and **#voteno** were often used in conjunction with it.

We decided to scrape Twitter, starting the week before the referendum, to see how Twitter users were leaning, and how it altered in the run-up to the vote itself.

## Swarmize configuration

We set up a new Swarm, with four fields:

* Are you for an independent Scotland? [boolean]
* What is your twitter screenname? [text]
* Full text of your tweet [text]
* Where was your tweet from? [Geolocation]

We phrased these as questions so that the results would be self-explanatory on swarmize.com .

The swarm was opened immediately, and not given a close time: we'd close it in due course. With that set up, we could pipe data into the Swarm.

## Implementation

To input data into the Swarm, Graham wrote a small Scala tool to hit the Twitter streaming search API, looking for all tweets containing '#indyref'. Then, we counted any also hashtagged as #yes or #voteyes as "Yes" tweets, and those tagged #no or #voteno as "No tweets". 

The boolean state of their vote, the full content of the tweet, and the tweet's username were all passed to the Collector API as JSON - and if the tweet was geolocated, we added the latlon, to be stored as a Geolocation field. The Scala tool was the matter of an hour or two's work.

## Results

In total, the swarm received 94k+ tweets.

I set up three graphs on the page:

* a pie graph of yes/no counts
* a pie graph of yes/no counts, aggregated by user name (so that duplicate statuses from a user wouldn't count)
* a timeseries graph of yes/no over time.

The absolute yes/no counts came out as *78.2%* "yes" to indepdendence (*true*, according to the boolean field) and *21.8%* "no".

Filtering these by user name - ie, deduplicating multiple identical 'votes' by users - gave us *71.8%* yes, *28.2%* no. Which indicates that the "yes" campaign were more vocal on social media, because they were repeating themselves more often - and thus had a smaller proportion in the deduplicated results.

Both, however, are disproportionate compared to the final vote - 55.3% *no*, 44.7% *yes* - which tells us a bit about how the audience on social media (at a guess: younger, more progressive) compares to the country as a whole.

Finally, the timeseries graph tells a clearer story:

* we see a trough that bottoms out around 3am each day, as people go to sleep.
* the 'yes' vote leads the 'no' vote almost entirely throughout - though we see the same pattern roughly repeated in both 'yes' and 'no' votes
* each day up to the refernedum, the overall volume of votes increases, up to a maximum peak (per hour) at 9pm the night before
* it's only on the day of the referendum (September 18th) - which eventually resolved as a 'no' outcome - that we see the 'yes' vote falling as the day goes on, rather than rising; by 3am the next day (September 19th) 'no' overtakes 'yes' for the first time.