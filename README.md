# DevOp Projects
## Terraform Projects (v0.11-v.014)
Here are just a number of projects where I am fully invested with Terraform since I believe it is much easier to use than CloudFormation and also less headache compared to others.
- VPC architecture with a web server and database server with an ASG. I am able to create
 6 subnets but having issues with the NAT Gateway choosing the subnet. (Needs to be worked on)
- Created a VPC architecture with 4 EC2 instances combined with an ASG that has Microsoft SQL Server installed. (Trying to find a way of scripting EBS volumes on all 4 instances if the instance is to fail.)
- Created a VPC architecture with an EC2 instance combined with an ASG that has Jenkins and Docker installed.
- S3 creation
- ECS Django build using AWS ECS using dynamic mapping for ports to keep it secure. This still needs to be worked on with the containers since I am receiving an error which I do not know why dealing with Django's ALLOWED_HOSTS.

#### Parameter file
#### This file will determine the region, vpc_cidr, public_subnet(s), private_subnet(s), and AMIs. (Remember, AMIs are different for every region.)
- var.tf

#### Important file to include in your project BUT must be removed from PUBLIC USE (use .gitignore)
##### This file will include your CONFIDENTIAL information. DO NOT allow this file to be put for the public because they will have programmatic access in your account which spells BAD.
- terraform.tfvars
```
AWS_ACCESS_KEY = "access key here"
AWS_SECRET_KEY = "secret key here"
AWS_KEY_PATH = "key path here" <here is an example: ~/.ssh/KeyTest.pem>
```

## CloudFormation Projects
There are not as much projects compared to Terraform but use them to your own expense.
- (AWS) Created a VPC architecture housing an EC2 instance
- (AWS) Created a VPC architecture with a EC2 instance (private instance), Load Balancer, and a Auto Scaling Group (for the Bastion Host when needed).