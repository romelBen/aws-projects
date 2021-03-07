############ Jenkins Instance Configuariton ###############
# Create Launch Configuration
resource "aws_launch_configuration" "jenkins-launch-setup" {
  name = "Jenkins Launch Configuration"
  image_id = "${lookup(var.AMIS-jenkins, var.AWS_REGION)}"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.sg-jenkins.id}"]
  key_name        = "${var.AWS_KEY_NAME}"
  user_data       = "${file("jenkins-install.sh")}"

  lifecycle {
    create_before_destroy = true
  }
}

# Create an Auto Scaling Group
resource "aws_autoscaling_group" "jenkins-asg" {
  name = "Jenkins ASG"
  launch_configuration = "${aws_launch_configuration.jenkins-launch-setup.id}"
  min_size             = 1
  max_size             = 3
  desired_capacity     = 1
  health_check_type    = "ELB"
  #load_balancers       = "$[aws_elb.elb-terraform.id]"
  vpc_zone_identifier  = "${aws_subnet.public_subnet.*.id}"
  tag {
    key                 = "Name"
    value               = "Jenkins-asg-terraform"
    propagate_at_launch = true
  }
}

######### Ansible Instance Configuration #############
# Create Launch Configuration
resource "aws_launch_configuration" "ansible-launch-setup" {
  name = "Ansible Launch Configuration"
  image_id = "${lookup(var.AMIS-RHEL8, var.AWS_REGION)}"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.sg-ansible.id}"]
  key_name        = "${var.AWS_KEY_NAME}"
  user_data       = "${file("ansible-install.sh")}"

  lifecycle {
    create_before_destroy = true
  }
}

# Create an Auto Scaling Group
resource "aws_autoscaling_group" "ansible-asg" {
  name = "Ansible ASG"
  launch_configuration = "${aws_launch_configuration.ansible-launch-setup.id}"
  min_size             = 1
  max_size             = 3
  desired_capacity     = 1
  health_check_type    = "ELB"
  #load_balancers       = "$[aws_elb.elb-terraform.id]"
  vpc_zone_identifier  = "${aws_subnet.public_subnet.*.id}"
  tag {
    key                 = "Name"
    value               = "Ansible-asg-terraform"
    propagate_at_launch = true
  }
}