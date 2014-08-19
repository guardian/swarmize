#!/bin/sh

APP_NAME=collector

# clear up stuff left behind from previous builds
[ -d ${APP_NAME}/target/docker ] && rm -rf ${APP_NAME}/target/docker

# build the zip
sbt ${APP_NAME}/docker:stage && \
  cd ${APP_NAME}/target/docker && \
  zip -r ../../${APP_NAME}.zip *

echo "I've built ${APP_NAME}.zip as a docker image. Now upload this as new version to elasticbeanstalk, and deploy"

