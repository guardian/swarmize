#!/bin/sh

sbt collector/universal:packageZipTarball

aws --profile swarmize --region eu-west-1 \
    s3 cp collector/target/universal/swarmize-collector.tgz s3://swarmize-bin/collector.tar.gz --acl public-read

aws --profile swarmize --region eu-west-1 \
    s3 cp collector/collector.conf s3://swarmize-bin/collector.conf --acl public-read
