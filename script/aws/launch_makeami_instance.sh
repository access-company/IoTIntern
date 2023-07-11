#!/bin/bash
set -euo pipefail

usage() {
cat <<EOF
Usage:
  $(basename "$0") <BOOTSTRAP_FILE>
EOF
}

if [ $# -lt 1 ]; then
  usage
  exit
fi

export AWS_PAGER=""
file=$(realpath "${1?}")
if ! [ -f "$file" ]; then
  echo "File not found: $file"
fi

find_image_id() {
  aws ec2 describe-images \
    --profile iot_intern \
    --owner amazon \
    --filters "Name=architecture,Values=x86_64" \
      "Name=virtualization-type,Values=hvm" \
      "Name=name,Values=amzn2-ami-kernel-*" \
      "Name=state,Values=available" \
    --query Images \
  | jq -r "sort_by(.CreationDate)[-1].ImageId"
}

find_subnet_id() {
  aws ec2 describe-subnets \
    --profile iot_intern \
    --query "Subnets[0].SubnetId" \
    --output text
}

gen_block_device_mappings() {
  echo '
    [
      {
        "DeviceName": "/dev/xvda",
        "Ebs": {
          "DeleteOnTermination": true,
          "VolumeSize": 16,
          "VolumeType": "gp3"
        }
      }
    ]
  '| jq --compact-output --monochrome-output .
}

find_security_group_id() {
  aws ec2 describe-security-groups \
    --profile iot_intern \
    --group-names "iot-intern" \
    --query "SecurityGroups[].GroupId" \
    --output text
}

run_instance() {
  image_id="$(find_image_id)"
  subnet_id="$(find_subnet_id)"
  block_device_mappings="$(gen_block_device_mappings)"
  instance_name="iot-intern-makeami-$(date +'%Y%m%d')"
  security_group_id="$(find_security_group_id)"

  aws ec2 run-instances \
    --profile iot_intern \
    --image-id "$image_id" \
    --instance-type "t3.micro" \
    --subnet-id "$subnet_id" \
    --user-data "file://${file}" \
    --block-device-mappings "$block_device_mappings" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${instance_name}}]" \
    --security-group-ids "$security_group_id"
  echo "Launched instance name: ${instance_name}"
}

set -x
run_instance
