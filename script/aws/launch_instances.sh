#!/bin/bash
set -euo pipefail

usage(){
cat <<EOF
Usage:
  $(basename "$0") <BASE_IMAGE_ID> <NUMBER_OF_INSTANCES>
EOF
}

if [ $# -lt 2 ]; then
  usage
  exit
fi

export AWS_PAGER=""
image_id="$1"
instance_count="$2"

find_security_group_id() {
  aws ec2 describe-security-groups \
    --profile iot_intern \
    --group-names "iot-intern" \
    --query "SecurityGroups[].GroupId" \
    --output text
}

run_instances(){
  security_group_id="$(find_security_group_id)"

  aws ec2 run-instances \
    --profile iot_intern \
    --image-id "${image_id}" \
    --count "${instance_count}" \
    --instance-type 't2.micro' \
    --security-group-ids "${security_group_id}" \
    --tag-specifications "ResourceType='instance',Tags=[{Key='Name',Value='iot-intern'}]"
}

set -x
run_instances
