#!/bin/sh

. cfn.conf

. bashlib/shared.sh

uploadTemplates

echo "Validating cloudformation script..."

${AWS_CMD} cloudformation validate-template \
 --template-url "$S3_CFN_URL/all.template"







