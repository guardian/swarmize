#!/bin/sh

CURRENTREV=$(git log --pretty=format:'%h' -n 1)
pushd . > /dev/null
cd ..
echo "Archiving website to package-$CURRENTREV.zip"
git archive -o mock-website/package-$CURRENTREV.zip master:mock-website
popd > /dev/null

#aws s3 cp target/universal/swarmize-collector.tgz s3://swarmize-dist/collector.tar.gz --acl public-read
#aws s3 cp collector.conf s3://swarmize-dist/collector.conf --acl public-read

