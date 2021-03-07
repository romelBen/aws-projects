variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_KEY_PATH" {}
variable "AWS_KEY_NAME" {}

variable "AWS_REGION" {
  default = "us-east-1"
}

# CIDR block
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

# Public Subnets that will be used
variable "public_subnet_cidr" {
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

# SQL AMI being used in us-east-1
variable "SQL-AMI" {
  type = "map"
  default = {
    us-east-1 = "ami-00cb4c0d60b9476f4" # Microsoft Windows Server 2019
  }
}

# Block names for the EBS volumes
variable "ebs_block_names" {
  default = [
    "/dev/xvdb",
    "/dev/xvdc",
    "/dev/xvdd",
    "/dev/xvde"
  ]
}