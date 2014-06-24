#!/bin/sh

. cfn.conf

. bashlib/shared.sh


${AWS_CMD} --output text cloudformation describe-stack-events \
 --stack-name "$STACK_NAME" --max-items 20 | \
 grep STACKEVENTS | awk -F\t '{ print $11, $6, $3 }'







