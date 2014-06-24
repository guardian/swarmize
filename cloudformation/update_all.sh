#!/bin/sh

. cfn.conf

. bashlib/shared.sh

uploadTemplates

echo "Updating cloudformation for $STACK_NAME..."

${AWS_CMD} cloudformation update-stack \
 --stack-name "$STACK_NAME" \
 --template-url "$S3_CFN_URL/all.template" \
 --capabilities CAPABILITY_IAM \
 --parameters ParameterKey=TemplateBucketPath,ParameterValue=${S3_CFN_URL} \
    ParameterKey=DistBucketPath,ParameterValue=${S3_DIST_URL}








