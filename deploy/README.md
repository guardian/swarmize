# Swarmize deployment tools

This directory contains the bulk of the Swarmize deployment tools.

## Prerequisites

`deploy` was written against Ruby 1.9.3. You'll need this installed, along with Bundler. `rbenv` is recommended if you don't have a Ruby installed.

## Installation

From the `deploy` directory, run

	bundle install
	
to install all necessary dependencies.

## Configuration

The AWS gem will make use of the AWS CLI configuration, stored in `~/.aws`. Make sure you have Swarmize creds in there.

## Setting up your subfolder for deployment

A subfolder requires three things to be deployable:

* a `eb_name.txt` file, containing the name of the application on Elastic Beanstalk
* a `package.sh` file, containing all the code to get a zip file of the deployable application.

## How it works

The root folder's `./deploy.sh` script simply sets up the appropriate environment variables needed by `deploy.rb`, and passes the app to be deployed to `deploy.rb`.

`deploy.rb` then:

* finds the latest version of the application and checks it hasn't been uploaded already
* if not, it packages the application and uploads the resulting zipfile to S3.
* then, the deploy script tries to make a new version of the application with that code, and apply it to the live version
* finally, it notifies Slack that a deployment has taken place.

## Usage

From the root of the repository - not the deploy folder - run

	./deploy.sh [thing-to-deploy]
	
eg

	./deploy.sh swarmize-dot-com
