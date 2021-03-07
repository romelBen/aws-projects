## EC2 instance (with Microsoft SQL Server) + EBS volume attachment architecture
This template uses AWS services such as:
- Auto Scaling
- Script to attach ebs volumes to the EC2 instances (needs to be worked on)
- EC2 instances (Initially, 4 instances will be brought up but this can be changed in file asg.tf)
- VPC