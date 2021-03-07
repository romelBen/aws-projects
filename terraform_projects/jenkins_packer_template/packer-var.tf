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

variable "INSTANCE_DEVICE_NAME" {
  default = "/dev/xvdh"
}

variable "JENKINS_VERSION" {
  default = "2.230"
}

variable "TERRAFORM_VERSION" {
  default = "0.12.24"
}

variable "APP_INSTANCE_COUNT" {
  default = "0"
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

variable "APP_INSTANCE_AMI" {
  default = ""
}

