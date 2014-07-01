#!/bin/sh

S3_CFN_PATH="s3://$BUCKET_NAME/cfn/"
S3_CFN_URL="https://s3.amazonaws.com/$BUCKET_NAME/cfn"
S3_DIST_PATH="s3://$BUCKET_NAME/"
S3_DIST_URL="https://s3.amazonaws.com/$BUCKET_NAME"
AWS_CMD="aws --region $REGION"

echo "Region: $REGION"


uploadTemplates()
{
    echo "Uploading templates to $S3_CFN_PATH..."

    ${AWS_CMD} s3 sync . ${S3_CFN_PATH} --exclude "*" --include "*.template" --acl public-read

    echo "Uploading distribution files to $S3_DIST_URL..."

    ${AWS_CMD} s3 sync dist ${S3_DIST_PATH} --acl public-read

}