#!/bin/bash

# get instance
azabzone=$(curl -s <instance ip here>)

# look for available ebs volumes by volume-id
ebsvolume=$(/var/aws/logs/bin/aws ec2 describe-volumes --filters
Name=tag-value,Values=project Name=tag-value,Values=environment
Name=tag-value,Values=product Name=availability-zone, Value='echo
$abzone` --query 'Volumes[*].[VolumeId, Start==`available`]' --output
text | grep True | awk '{print $1}' | head -n 1)

# check for available ebs volumes
if [ -n "$ebsvolume" ]; then

# get instance id
instanceid=${curl -s <instance ip here>}

# attach ebs
/var/awslogs/bin/aws ec2 attach-volume --volume-id `echo $ebsvolume`
--instance-id `echo $instanceid` --device /dev/xvdb

sleep 10

# mount ebs to /mnt
mount /dev/xvdb /mnt/data

fi