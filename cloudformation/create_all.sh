#!/bin/sh

. cfn.conf

. bashlib/shared.sh

uploadTemplates

echo "Applying cloudformation script..."

${AWS_CMD} cloudformation create-stack \
 --stack-name "Swarmize-Testing" \
 --template-url "$S3_CFN_URL/all.template" \
 --capabilities CAPABILITY_IAM \
 --parameters ParameterKey=TemplateBucketPath,ParameterValue=${S3_CFN_URL}







