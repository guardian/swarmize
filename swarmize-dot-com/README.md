# swarmize.com web application

This directory contains the code for `alpha.swarmize.com`. The web application handles:

* creating and designing Swarms
* setting Swarms' open/close times
* cloning and deleting swarms
* giving other users permission to edit swarms
* generating CSV of a swarm
* displaying realtime results from a swarm
* displaying overview graphs from a swarm
* creating and revoking API keys
* generating embeddable forms
* listing the various field names for the Collector API

## Prerequisites

`swarmize-dot-com` was written against Ruby 1.9.3 and Postgres 9.3.3. You'll need these installed, along with Bundler. `rbenv` is recommended if you don't have a Ruby installed.

## Installation

Assuming you've met the prerequisites above, from this directory, run

	bundle install
	
to install all the necessary gems for Swarmize.

## Configuration

Before you can run Swarmize, you'll need to perform some configuration. The necessary configuration is all stored as environment variables. In production, these will be loaded from your server's environment. However, in development, we use the `dotenv` gem to load them from the `.env` file.

A `.env.sample` file has been supplied, which needs the following environment variables specifying:

* `ELASTICSEARCH_HOST` - the hostname of the elasticsearch server. Normally, this is `elasticsearch.swarmize.com`, which is only accessible inside the production AWS Security Group, or from Kings' Place. You may wish to set this to (eg) localhost, and set up an SSH tunnel to the elasticsearch server.
* `GOOGLE_CLIENT_ID` - the client ID for Google Authentication.
* `GOOGLE_CLIENT_SECRET` - the Client Secret for Google Authentication. (Both of these will come from your Google Developer configuration).
* `AWS_ACCESS_KEY_ID` - the AWS Access Key ID for Swarmize. You may already have this set up as a system environment variable, in which case this line isn't necessary.
* `AWS_SECRET_ACCESS_KEY` - the AWS Secret Access Key for Swarmize. You may already have this set up as a system environment variable, in which case this line isn't necessary.

You'll also need to configure your local Postgres setup in `config/database.yml`. `config/database.yml` is supplied as a template for this.

Once you've done all this, you should set up the database tables by migrating the database:

	rake db:migrate

## Running

With all the configuration in place, you'll be able to run the website locally. From this directory:

	rails s
	
will spin up a server on `localhost:3000`

Note that you'll need a connection to the elasticsearch server for much of the site to function correctly.

## Importing Swarms

In development, it's possible to import a swarm from the live site exactly is is (copying the fields, the token, and thus having access to the same data). To do so:

* having logged in, from the top nav, choose Swarms -> Import Swarm From JSON
* input the URL to the swarm on the production site, eg `http://alpha.swarmize.com/swarms/rycadjgp`
* click 'import'

If no swarm with that token exists locally, it'll be created, with all fields and data appearing identically. (It clones the swarm using the JSON representation of the swarm available at eg `http://alpha.swarmize.com/swarms/rycadjgp.json`)

## Deployment

swarmize.com is deployed through the standard Swarmize deployment tool. `package.sh` is the packaging command specific to the application, and `eb_name.txt` is the name of the application on ElasticBeanstalk.

## Notes

### What's in `lib`

As with most Rails apps, `lib` is a grab-bag of bits and bobs. Namely:

* `dummy.rb` - a useful class for making dummy swarms, users, and the like.
* `dynamo_sync.rb` - the class that does all the heavy lifting of syncing a swarm to DynamoDB
* `email_validator.rb` - a tiny class for ensuring that email addresses used to login are allowed access to Swarmize
* `json_importer.rb` - a class for importing a swarm to your local dev environment from the production environment. Useful for copying something on live to your developer setup to explore/debug it.
* `swarm_csv_tool.rb` - important, this: this is an object for generating CSV, a line at a time, from a swarm
* `swarmize_oembed.rb` - a class to handle everything to do with oembed: generating it, validating the request
* `swarmize_search.rb` - probably the most important class here. This deals with making requests for a swarm to Elasticsearch, and returning the results as a `Hashie::Mash` (because dot-notation object access seems more sensible than key-based access). This class contains one method per request you might make - eg `all`, `latest`. These methods deal with making the query, getting the data back, and structuring it into an object for the Rails app. However, the queries themselves are contained in:
* `swarmize_search/queries.rb` - this file, which contains the various JSON queries for each search request, defined as `Jbuilder` objects. It seemed sensible to keep them nice and tidy.

### What's in `application_controller.rb`

* utilities to redirect after authentication
* methods to check for a user or an admin
* method to set up the current user based on the session.

### Templates

Are written in [HAML.](http://haml.info/)

### Tests / Specs

There are specs written in [RSpec](http://rspec.info/). They are not entirely comprehensive, but focus on particularly critical areas: authentication; confirming who's allowed to access Swarmize; confirming when a Swarm is considered open/closed; and, most importantly, what parts of the site are public and what require authentication (as a user and/or as an admin). They are also not particularly fast, but they do the job. More specs are always welcome.

### Authentication

Is done through Omniauth, and, specifically, the [`google-oauth2`](https://github.com/zquestz/omniauth-google-oauth2) strategy for it.