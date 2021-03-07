############ Microsoft SQL Server Configuariton ###############
# Create Launch Configuration
resource "aws_launch_configuration" "sqlserver-launch-setup" {
  name = "SQL Launch Configuration"
  image_id = "${lookup(var.SQL-AMI, var.AWS_REGION)}"
  instance_type   = "t2.small"
  security_groups = ["${aws_security_group.sql-sg.id}"]
  key_name        = "${var.AWS_KEY_NAME}"
  user_data       = "${file("attach_ebs.sh")}"

  root_block_device {
    volume_type = "gp2"
    volume_size = 30
    delete_on_termination = "true"
  }

  ebs_block_device {
    device_name = "/dev/xvdb, /dev/xvdc, /dev/xvdd, /dev/xvde" # needs to be reworked
    volume_size = "150"
    volume_type = "gp2"
    delete_on_termination = "true" # FOR TESTING PURPOSES ONLY
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create an Auto Scaling Group for Microsoft SQL Server
resource "aws_autoscaling_group" "sqlserver-asg" {
  name = "SQL ASG"
  launch_configuration = "${aws_launch_configuration.sqlserver-launch-setup.id}"
  min_size             = 4
  max_size             = 5
  desired_capacity     = 4
  health_check_type    = "ELB"
  #load_balancers       = "$[aws_elb.elb-terraform.id]"
  vpc_zone_identifier  = "${aws_subnet.public_subnet.*.id}"
  tag {
    key                 = "Name"
    value               = "SQL-ASG-terraform"
    propagate_at_launch = true
  }
}
