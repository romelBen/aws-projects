variable "AWS_ACCESS_KEY" {
}

variable "AWS_SECRET_KEY" {
}

variable "AWS_KEY_PATH" {
}

variable "AWS_KEY_NAME" {
}

variable "AWS_REGION" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "AMIS-jenkins" {
  type = "map"
  default = {
    us-east-1 = "ami-0a887e401f7654935" # AWS Linux 2 AMI
  }
}

variable "AMIS-RHEL8" {
  type = "map"
  default = {
    us-east-1 = "ami-098f16afa9edf40be" # RHEL8
  }
}

