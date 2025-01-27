#!/usr/bin/env bash

set -eu

region="us-west-2"
key_name="bcitkey"

source ./infrastructure_data

# Get Ubuntu 23.04 image id owned by amazon
ubuntu_ami=$(aws ec2 describe-images --region $region \
 --owners amazon \
 --filters Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-lunar-23.04-amd64-server* \
 --query 'sort_by(Images, &CreationDate)[-1].ImageId' --output text)


# Create security group allowing SSH and HTTP from anywhere
security_group_id=$(aws ec2 create-security-group --group-name MySecurityGroup \
 --description "Allow SSH and HTTP" --vpc-id $vpc_id --query 'GroupId' \
 --region $region \
 --output text)

aws ec2 authorize-security-group-ingress --group-id $security_group_id \
 --protocol tcp --port 22 --cidr 0.0.0.0/0 --region $region

aws ec2 authorize-security-group-ingress --group-id $security_group_id \
 --protocol tcp --port 80 --cidr 0.0.0.0/0 --region $region

# Launch an EC2 instance in the public subnet
# COMPLETE THIS PART
instance_id=

# wait for ec2 instance to be running
aws ec2 wait instance-running --instance-ids $instance_id

# Get the public IP address of the EC2 instance
# COMPLETE THIS PART
public_ip=

# Write instance data to a file
# COMPLETE THIS PART
echo "Public IP: $public_ip" 
