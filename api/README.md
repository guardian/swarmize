# Swarmize Retrieval API

This small Sinatra app is a prototype retrieval API for Swarmize. This file explains how to install and run it; `API_DOC.md` is the actual documentation for the API itself.

## Prerequisites

`api` was written against Ruby 1.9.3. You'll need this installed, along with Bundler. `rbenv` is recommended if you don't have a Ruby installed.

## Installation

Assuming you've met the prerequisites above, from this directory, run

	bundle install
	
to install all the necessary gems for the API.

## Configuration

Before you can run Swarmize, you'll need to perform some configuration. The necessary configuration is all stored as environment variables. In production, these will be loaded from your server's environment. However, in development, we use the `dotenv` gem to load them from the `.env` file.

A `.env.sample` file has been supplied, which needs the following environment variables specifying:

* `ELASTICSEARCH_HOST` - the hostname of the elasticsearch server. Normally, this is `elasticsearch.swarmize.com`, which is only accessible inside the production AWS Security Group, or from Kings' Place. You may wish to set this to (eg) localhost, and set up an SSH tunnel to the elasticsearch server.
* `AWS_ACCESS_KEY_ID` - the AWS Access Key ID for Swarmize. You may already have this set up as a system environment variable, in which case this line isn't necessary.
* `AWS_SECRET_ACCESS_KEY` - the AWS Secret Access Key for Swarmize. You may already have this set up as a system environment variable, in which case this line isn't necessary.


## Running

With all the configuration in place, you'll be able to run the website locally.  Because it's a standard API, runnning

	rackup
	
from this directory will spin up a server on `localhost:9292`.

In development, you'll probably want to use the included `shotgun` gem:

	shotgun
	
to spin up a server on `localhost:9393` that will reload on each page hit - useful for testing altered code.

Note that you'll need a connection to the elasticsearch server for much of the site to function correctly.