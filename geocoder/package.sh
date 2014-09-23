#!/bin/sh

PACKAGE_FILENAME=$1
DIRECTORY=$2

cd ..

git archive -o ${DIRECTORY}/${PACKAGE_FILENAME} master:${DIRECTORY}
