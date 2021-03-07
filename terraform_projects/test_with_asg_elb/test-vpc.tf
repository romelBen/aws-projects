# Looks through all zones in an AZ
data "aws_availability_zones" "available" {}

# Internet VPC
resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "Terraform VPC"
  }
}

# Internet GW
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"
  tags = {
    Name = "Terraform VPC IGW"
  }
}

# Elastic IP Address
resource "aws_eip" "elastic-ip" {
  count = "${length(data.aws_availability_zones.available.names)}"
  vpc = true
}

# NAT Gateway
resource "aws_nat_gateway" "nat-gw" {
  count = "${length(data.aws_availability_zones.available.names)}"
  subnet_id = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  allocation_id = "${element(aws_eip.elastic-ip.*.id, count.index)}"

  tags = {
    Name = "NAT-${element(data.aws_availability_zones.available.names, count.index)}"
  }
}

# Public Subnets
resource "aws_subnet" "public_subnet" {
  count = "${length(data.aws_availability_zones.available.names)}"
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${element(var.public_subnet_cidr, count.index)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet-${element(data.aws_availability_zones.available.names, count.index)}"
  }
}

# Application Subnets
resource "aws_subnet" "application_subnet" {
  count = "${length(data.aws_availability_zones.available.names)}"
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${element(var.application_subnet_cidr, count.index)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = false
  tags = {
    Name = "Application Subnet-${element(data.aws_availability_zones.available.names, count.index)}"
  }
}

# Database Subnets
resource "aws_subnet" "database_subnet" {
  count = "${length(data.aws_availability_zones.available.names)}"
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${element(var.database_subnet_cidr, count.index)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = false
  tags = {
    Name = "Database Subnet-${element(data.aws_availability_zones.available.names, count.index)}"
  }
}