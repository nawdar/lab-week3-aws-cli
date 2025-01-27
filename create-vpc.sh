#!/usr/bin/env bash

set -eu

# Variables
REGION="us-west-2"
VPC_CIDR="10.0.0.0/16"
SUBNET_CIDR="10.0.1.0/24"

# Create a VPC
VPC_ID=$(aws ec2 create-vpc --cidr-block $VPC_CIDR --query 'Vpc.VpcId' --output text --region $REGION)
echo "VPC created with ID: $VPC_ID"

# Add a Name tag to the VPC
aws ec2 create-tags --resources $VPC_ID --tags Key=Name,Value=MyVPC --region $REGION

# Enable DNS hostname resolution for the VPC
aws ec2 modify-vpc-attribute --vpc-id $VPC_ID --enable-dns-hostnames '{"Value":true}'

# Create a public subnet
SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID \
  --cidr-block $SUBNET_CIDR \
  --availability-zone ${REGION}a \
  --query 'Subnet.SubnetId' --output text --region $REGION)
echo "Subnet created with ID: $SUBNET_ID"

# Enable auto-assign public IPs for the subnet
aws ec2 modify-subnet-attribute --subnet-id $SUBNET_ID --map-public-ip-on-launch

# Create an Internet Gateway
IGW_ID=$(aws ec2 create-internet-gateway --query 'InternetGateway.InternetGatewayId' --output text --region $REGION)
echo "Internet Gateway created with ID: $IGW_ID"

# Attach the Internet Gateway to the VPC
aws ec2 attach-internet-gateway --vpc-id $VPC_ID --internet-gateway-id $IGW_ID --region $REGION

# Create a route table for the VPC
ROUTE_TABLE_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --query 'RouteTable.RouteTableId' --output text --region $REGION)
echo "Route Table created with ID: $ROUTE_TABLE_ID"

# Create a route to the Internet Gateway
aws ec2 create-route --route-table-id $ROUTE_TABLE_ID \
  --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID --region $REGION

# Associate the route table with the public subnet
aws ec2 associate-route-table --subnet-id $SUBNET_ID --route-table-id $ROUTE_TABLE_ID --region $REGION

# Write VPC and Subnet IDs to a file for later use
echo "vpc_id=${VPC_ID}" > infrastructure_data
echo "subnet_id=${SUBNET_ID}" >> infrastructure_data

echo "VPC and subnet setup complete!"
