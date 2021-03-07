provider "aws" {
  access_key = "${var.AWS_ACCESS_KEY}"
  secret_key = "${var.AWS_SECRET_KEY}"
  region = "${var.AWS_REGION}"
}

# Configuration to be for any region
data "aws_region" "current" {}

# Finds each avaiability zones for each region
data "aws_availability_zones" "avaiable" {}

data "aws_ami" "eks-worker" {
    most_recent = true
    owners = ["romelben"]
  
  filter {
      name = "Romel"
      values = ["amazon-eks-node-${aws_eks_cluster.master-eks.version}-v*"]
  }
}
