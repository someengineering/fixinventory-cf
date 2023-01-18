#!/bin/bash
extra_regions="us-gov-east-1 us-gov-west-1 cn-north-1 cn-northwest-1"
for region in $(aws ec2 describe-regions --region us-east-1 | jq -r .Regions[].RegionName | sort) $extra_regions
do
    echo "    - $region"
done
