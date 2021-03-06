resource "aws_elb" "main-elb" {
  name = "Terraform ELB"
  security_groups = "${aws_security_group.sg-jenkins.id}"
  availability_zones = "${data.aws_availability_zones.available.names}"
  health_check {
      healthy_threshold = 2
      unhealthy_threshold = 2
      timeout = 3
      interval = 30
      target = "HTTP:8080/"
  }
  listener {
      lb_port = 80
      lb_protocol = "http"
      instance_port = "8080"
      instance_protocol = "http"
  }
}
