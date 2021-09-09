#!/bin/bash

USER_NAME="intern-user"

usage(){
  cat<<EOF
Usage:
  $(basename "$0") <path to ssh key for ${USER_NAME}>
EOF
}

user_key_path="$1"

if [ $# -lt 1 ]; then
  usage
  exit
fi

REMOTE_TARGET_DIR="/home/${USER_NAME}/IoTIntern"
now=$(date +%Y%m%d%H%M%S)
LOCAL_DOWNLOAD_DIR="./tmp-downloaded/${now}"
mkdir -p "${LOCAL_DOWNLOAD_DIR}"
script_dir=$(dirname "$0")

for host_and_public_ip_pairs in $("${script_dir}/list_public_ip_addresses.sh"); do
  hostname=$(echo "${host_and_public_ip_pairs}" | cut -d ',' -f1)
  ip=$(echo "${host_and_public_ip_pairs}" | cut -d ',' -f2)
  echo "Start downlading from ${hostname}..."

  # REMOTE_TARGET_DIR should be expanded before transferred to remote
  # shellcheck disable=SC2087
  ssh -i "${user_key_path}" -o StrictHostKeyChecking=no "${USER_NAME}@${ip}" <<EOC
rm -rf ${REMOTE_TARGET_DIR}/_build
rm -rf ${REMOTE_TARGET_DIR}/deps
EOC

  scp -i "${user_key_path}" -o StrictHostKeyChecking=no -r "${USER_NAME}@${ip}:${REMOTE_TARGET_DIR}" "${LOCAL_DOWNLOAD_DIR}/${hostname}"
  echo "Done."
done
