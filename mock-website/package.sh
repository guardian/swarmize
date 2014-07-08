#!/bin/sh

echo "Removing old packages."
rm package*.zip
CURRENTREV=$(git log --pretty=format:'%h' -n 1)
pushd . > /dev/null
cd ..
echo "Archiving website to package-$CURRENTREV.zip"
git archive -o mock-website/package-$CURRENTREV.zip master:mock-website
popd > /dev/null

echo "Uploading to S3."

aws s3 cp package-$CURRENTREV.zip s3://swarmize-demo/package-$CURRENTREV.zip

echo "Deploying new application version"

aws elasticbeanstalk create-application-version --application-name "My First Elastic Beanstalk Application" --version-label package-$CURRENTREV --source-bundle S3Bucket=swarmize-demo,S3Key=package-$CURRENTREV.zip
