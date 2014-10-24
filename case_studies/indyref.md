# Real world use: the #indyref swarm

In the run up to the Scottish referendum, we decided to survey the mood of Twitter users tweeting about the referendum. Discussion around the referendum was focusing around the hashtag **#indyref**, and the hashtags **#voteyes** and **#voteno** were often used in conjunction with it.

Swarmize was a great fit for tracking these results for three reasons:

* what we had was, in essence, a **survey** - something that could be phrased as a series of questions. We were surveying which way a Twitter user was leaning, and we would track their usernames to see if they'd repeat themselves. But we were effectively asking the same question as the referendum: "*Do you think Scotland should be an indepedent country?*"
* we were interested in tracking those results **over time**: not just asking the question once, but seeing how people voted in the run-up to the election. Swarmize's focus on time-series data was an obvious fit here.
* we were looking for a **large volume of data**. Whilst Swarms don't *have* to be huge, the system can take the load of something very popular. Piping the Twitter search stream into Swarmize might lead to a glut of data - but that's something Swarmize just copes with.,

We would scrape Twitter from the week before the referendum, to see how Twitter users were leaning, and how it altered in the run-up to the vote itself.

## Swarmize configuration

We set up a new Swarm, with four fields:

![image](indyref/indyref1.gif)

* Are you for an independent Scotland? [boolean]
* What is your twitter screenname? [text]
* Full text of your tweet [text]
* Where was your tweet from? [Geolocation]

We phrased these as questions so that the results would be self-explanatory on swarmize.com .

The swarm was opened immediately, and not given a close time: we'd close it in due course. With that set up, we could pipe data into the Swarm.

## Implementation

To input data into the Swarm, Graham wrote [a small Scala tool](https://github.com/tackley/swarmize-indyref) to hit the Twitter streaming search API, looking for all tweets containing '#indyref'. Then, we counted any also hashtagged as #yes or #voteyes as "Yes" tweets, and those tagged #no or #voteno as "No tweets". 

The boolean state of their vote, the full content of the tweet, and the tweet's username were all passed to the Collector API as JSON - and if the tweet was geolocated, we added the latlon, to be stored as a Geolocation field. The Scala tool was the matter of an hour or two's work.

## Results

In total, the swarm received 94k+ tweets.

I set up three graphs on the page:

* a pie graph of yes/no counts
* a pie graph of yes/no counts, aggregated by user name (so that duplicate statuses from a user wouldn't count)
* a timeseries graph of yes/no over time.

![[img]](indyref/indyref-graph1.png)

The absolute yes/no counts came out as *78.2%* "yes" to indepdendence (*true*, according to the boolean field) and *21.8%* "no".

![[img]](indyref/indyref-graph2.png)

Filtering these by user name - ie, deduplicating multiple identical 'votes' by users - gave us *71.8%* yes, *28.2%* no. Which indicates that the "yes" campaign were more vocal on social media, because they were repeating themselves more often - and thus had a smaller proportion in the deduplicated results.

Both, however, are disproportionate compared to the final vote - 55.3% *no*, 44.7% *yes* - which tells us a bit about how the audience on social media (at a guess: younger, more progressive) compares to the country as a whole.

![[img]](indyref/indyref-graph3.png)

Finally, the timeseries graph tells a clearer story:

* we see a trough that bottoms out around 3am each day, as people go to sleep.
* the 'yes' vote leads the 'no' vote almost entirely throughout - though we see the same pattern roughly repeated in both 'yes' and 'no' votes
* each day up to the refernedum, the overall volume of votes increases, up to a maximum peak (per hour) at 9pm the night before
* it's only on the day of the referendum (September 18th) - which eventually resolved as a 'no' outcome - that we see the 'yes' vote falling as the day goes on, rather than rising; by 3am the next day (September 19th) 'no' overtakes 'yes' for the first time.