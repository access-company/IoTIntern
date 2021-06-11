#!/bin/bash
set -euo pipefail

usage() {
cat <<EOF
Usage:
  $(basename "$0") <BASE_INSTANCE_ID>
EOF
}

if [ $# -lt 1 ]; then
  usage
  exit
fi

export AWS_PAGER=""
instance_id="$1"

create_ami(){
  ami_name="iot-intern-$(date +"%Y%m%d")"

  image_id=$(aws ec2 create-image \
    --profile iot_intern \
    --instance-id "${instance_id}" \
    --name "${ami_name}" \
    --query ImageId \
    --output text
  )
  aws ec2 terminate-instances --profile iot_intern --instance-ids "${instance_id}"

  echo "Created AMI id: ${image_id}"
}

set -x
create_ami
