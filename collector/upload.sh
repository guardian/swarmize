#!/bin/sh

sbt universal:packageZipTarball

aws s3 cp target/universal/swarmize-collector.tgz s3://swarmize-dist/collector.tar.gz --acl public-read
aws s3 cp collector.conf s3://swarmize-dist/collector.conf --acl public-read
