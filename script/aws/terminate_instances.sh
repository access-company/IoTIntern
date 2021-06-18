#!/bin/bash
set -euo pipefail

export AWS_PAGER=""

instance_ids=$(
  aws ec2 describe-instances \
    --profile iot_intern \
    --filters 'Name=tag:Name,Values=iot-intern' 'Name=instance-state-name,Values=running' \
    | jq -r ".Reservations[].Instances[].InstanceId"
)

for instance_id in $instance_ids; do
  aws ec2 terminate-instances \
    --profile iot_intern \
    --instance-ids "${instance_id}"
done
