resource "aws_elb" "elb-terraform" {
  name               = "terraform-elb"
  #subnets = "${aws_subnet.public_subnet.*.id}"
  security_groups = ["${aws_security_group.sg-web.id}"]
  availability_zones = ["us-east-1a"]

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 10
    target              = "HTTP:8080/"
  }

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "8080"
    instance_protocol = "http"
  }

  tags = {
    Name = "Terraform-ELB"
  }
}

output "elb-dns-name" {
  value = "${aws_elb.elb-terraform.dns_name}"
}

