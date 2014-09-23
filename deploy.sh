#!/bin/sh

export AWS_PROFILE=swarmize
export AWS_REGION=eu-west-1
export S3_BUCKET=swarmize

deploy/deploy.rb $@
