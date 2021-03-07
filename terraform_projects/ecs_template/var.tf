# Here is the name of your ssh key will be built
variable "key_name" {
    type            = string
    decription      = "The name for your ssh key, used for aws_launch_configuration"
}

# Here is the creation of the ECS Cluster name
variable "cluster_name" {
    type            = string
    description     = "The name of the AWS ECS Cluster"
}