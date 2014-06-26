#!/bin/sh

. cfn.conf

. bashlib/shared.sh

echo "Deleting cloudformation stack $STACK_NAME..."

${AWS_CMD} cloudformation delete-stack \
 --stack-name "$STACK_NAME" \







