#!/bin/sh

export AWS_PROFILE=swarmize
export AWS_REGION=eu-west-1
export S3_BUCKET=swarmize
export SLACK_KEY=ysJzWEUc18R2H20e0UWw8qZH

deploy/deploy.rb $@
