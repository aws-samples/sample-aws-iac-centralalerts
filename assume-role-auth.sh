#!/bin/bash
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN

if [ -z "$1" ]; then
  # If not provided, assign the default value
  profile="default"
else
  # Otherwise, use the provided argument
  profile="$1"
fi
# replace the below role with role you want to assume.
# role should allow your base identity

OUT=$(aws sts assume-role --role-arn "arn:aws:iam::<ACCOUNT to Assume>:role/cross_account_admin_role" --role-session-name AWSCLI-Session --duration-seconds 3600 --profile "$profile");\
export AWS_ACCESS_KEY_ID=$(echo "$OUT" | jq -r '.Credentials''.AccessKeyId');\
export AWS_SECRET_ACCESS_KEY=$(echo "$OUT" | jq -r '.Credentials''.SecretAccessKey');\
export AWS_SESSION_TOKEN=$(echo "$OUT" | jq -r '.Credentials''.SessionToken');

echo "Assumed role successfully"
aws sts get-caller-identity --profile "$profile"
# How to use
# source assume-role-auth.sh
