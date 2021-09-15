#!/bin/bash
set -euo pipefail

export AWS_PAGER=""

list_public_ip_addresses(){
  ip_addresses=$(aws ec2 describe-instances \
    --profile iot_intern \
    --filters 'Name=tag:Name,Values=iot-intern' 'Name=instance-state-name,Values=running' \
    | jq -c '.["Reservations"] | map(.["Instances"]) | flatten | sort_by(.["LaunchTime"])' \
    | jq -r '.[].PublicIpAddress')

  index=0
  for ip_address in ${ip_addresses}; do
    echo "iot-intern-${index},${ip_address}"
    index=$((index + 1))
  done
}

list_public_ip_addresses
