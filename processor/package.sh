#!/bin/sh

PACKAGE_FILENAME=$1
DIRECTORY=$2

# clear up stuff left behind from previous builds
[ -d target/docker ] && rm -rf target/docker

# build the zip
cd ..

sbt processor/docker:stage && \
  cd ${DIRECTORY}/target/docker && \
  zip -r ../../${PACKAGE_FILENAME} *


