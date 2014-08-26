#!/bin/sh
aws --profile swarmize autoscaling update-auto-scaling-group \
  --auto-scaling-group-name awseb-e-6bv6raqwgv-stack-AWSEBAutoScalingGroup-18Q0FOJPKDO5R \
  --min-size 0 \
  --desired-capacity 0 