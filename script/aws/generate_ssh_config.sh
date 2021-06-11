#!/bin/bash
set -euo pipefail

#
# Usage (assuming that ~/.ssh/config.* is included by ~/.ssh/config):
# $ ./generate_ssh_config.sh > ~/.ssh/config.iot-intern
#

public_ip_addresses_of_running_instances(){
  aws ec2 describe-instances \
    --profile iot_intern \
    --filters 'Name=tag:Name,Values=iot-intern' 'Name=instance-state-name,Values=running' \
    | jq -c '.["Reservations"] | map(.["Instances"]) | flatten | sort_by(.["LaunchTime"])' \
    | jq -r '.[].PublicIpAddress'
}

output_config() {
  index=0
  echo "${1}" | while IFS="," read -r ip; do
    echo "Host iot-intern-${index}"
    echo "  User intern-admin"
    echo "  HostName ${ip}"
    index=$((index + 1))
  done
}

cat <<'EOF'
Host iot-intern-*
  User intern-admin
  IdentityFile ~/.ssh/iot-intern-admin-key

EOF

output_config "$(public_ip_addresses_of_running_instances)"
