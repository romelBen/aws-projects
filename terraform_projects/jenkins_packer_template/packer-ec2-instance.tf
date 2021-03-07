resource "aws_instance" "jenkins-instance" {
  ami = "${lookup(var.AMIS-jenkins, var.AWS_REGION)}"
  instance_type   = "t2.small"
  vpc_security_group_ids = ["${aws_security_group.sg-jenkins.id}"]
  key_name        = "${var.AWS_KEY_NAME}"
  user_data       = "${data.template_cloudinit_config.cloudinit-jenkins.rendered}"
}

resource "aws_ebs_volume" "jenkins-data" {
  availability_zone = "us-east-1"
  size = 20
  type = "gp2"

  tags = {
      Name = "jenkins-data"
  }
}

resource "aws_volume_attachment" "jenkins-data-attachment" {
  device_name = "${var.INSTANCE_DEVICE_NAME}"
  volume_id = "${aws_ebs_volume.jenkins-data.id}"
  instance_id = "${aws_autoscaling_group.jenkins-asg.id}"
  skip_destroy = true
}

resource "aws_instance" "app-instance" {
  count = "${var.APP_INSTANCE_COUNT}"
  ami = "${var.APP_INSTANCE_AMI}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.app-securitygroup.id}"]
  key_name = "${var.AWS_KEY_NAME}"
}
