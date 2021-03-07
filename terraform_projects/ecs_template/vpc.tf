### This module supports AWS's VPC architecture with 6 AZs and 6 Public Subnets
# Please make sure you have the latest version to support your architecture
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
module "vpc" {
    source          = "terraform-aws-modules/vpc/aws"
    version         = "2.64.0"
    name            = "ecs_provisioning"
    cidr            = "10.0.0.0/16"
    azs             = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
    public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

    tags = {
        "env"       = "dev"
        "tags"      = "romelben"
    }
}

data "aws_vpc" "main" {
    id = module.vpc.vpc_id
}

resource "aws_security_group" "ec2-sg" {
  name              = "allow-all-ec2"
  description       = "allow all"
  vpc_id            = data.aws_vpc.main.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "romelben"
  }
}

resource "aws_security_group" "ecs-sg" {
  name              = "allow-all-lb"
  vpc_id            = data.aws_vpc.main.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "env"       = "dev"
    "createdBy" = "romelben"
  }
}