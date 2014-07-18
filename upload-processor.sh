#!/bin/sh

sbt processor/universal:packageZipTarball

aws --profile swarmize --region eu-west-1 \
    s3 cp processor/target/universal/swarmize-processor.tgz s3://swarmize-bin/processor.tar.gz --acl public-read

aws --profile swarmize --region eu-west-1 \
    s3 cp processor/processor.conf s3://swarmize-bin/processor.conf --acl public-read
