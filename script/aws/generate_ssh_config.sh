#!/bin/bash
set -euo pipefail

#
# Usage (assuming that ~/.ssh/config.* is included by ~/.ssh/config):
# $ ./generate_ssh_config.sh > ~/.ssh/config.iot-intern
#

script_dir=$(dirname "$0")

output_config() {
  for host_and_public_ip_pairs in $("${script_dir}/list_public_ip_addresses.sh"); do
    hostname=$(echo "${host_and_public_ip_pairs}" | cut -d ',' -f1)
    ip=$(echo "${host_and_public_ip_pairs}" | cut -d ',' -f2)
    echo "Host ${hostname}"
    echo "  User intern-admin"
    echo "  HostName ${ip}"
  done
}

cat <<'EOF'
Host iot-intern-*
  User intern-admin
  IdentityFile ~/.ssh/iot-intern-admin-key

EOF

output_config
