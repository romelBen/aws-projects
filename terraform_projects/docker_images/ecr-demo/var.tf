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
variable "ECS_AMIS" {
    type = "map"
    default = {
        #These AMIs are Ubuntu
        us-east-1 = "ami-0b25b3d814fa986ce"
        us-east-2 = "ami-0d36f68a8c544bbbe"
        eu-west-1 = "ami-0406237fdb3437aec"
        eu-west-2 = "ami-08cad0202d4a23452"
    }
}