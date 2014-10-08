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