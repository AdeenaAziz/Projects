#!/bin/bash
# Author: Adeena aziz dar
# Date: 11-July 2026
# Version: v2
# Description: This script will report the AWS resource usage

set -x
echo "Print list of S3 buckets"
aws s3 ls
echo "Print list of EC2 instances"
#aws ec2 describe-instances
aws ec2 describe-instances | jq '.Reservations[].Instances[].InstanceId'

aws lambda list-functions
echo "Print list of IAM users"
aws iam list-users
