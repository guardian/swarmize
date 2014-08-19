# Swarmize

Swarmize is a stack of tools to make crowd-powered number-gathering a lot easier.

Currently in this repository:

* `cloudformation`: AWS CloudFormation config
* `collector`: Receive data from an endpoint and forward it to the stream. [scala]
* `epochtest`: Tom working out how Epoch works [node]
* `geocoder`: Simple Node geocoder endpoint [node]
* `livedebate`: Sample app: click on the face you're liking most at any point during a prime ministerial debate; the data - along with some demographic information - will be pushed into Swarm. [ruby]
* `mock-website`: Simple Sinatra-based front-end to Elasticsearch prototype [ruby]
* `processor`: Processes submitted data [scala]
* `sentiment-endpoint`: Simple Node sentiment analysis endpoint [node]
* `swarmize-dot-com`: the Swarmize alpha website. [ruby]

[![Build Status](https://travis-ci.org/guardian/swarmize.svg?branch=master)](https://travis-ci.org/guardian/swarmize)
