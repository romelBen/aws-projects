resource "aws_alb" "app-alb" {
  name = "Web-ELB"
  count = "${length(data.aws_availability_zones.available.names)}"
  subnets = "${element(var.application_subnet_cidr, count.index)}"
  security_groups = ["${aws_security_group.sg-elb.id}"]
#  availability_zones = "${data.aws_availability_zones.available.names}"
}

resource "aws_alb_target_group" "frontend-target-group" {
  name = "ALB-Target-Group"
  port = 80
  protocol = "HTTP"
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_alb_listener" "frontend-listeners" {
  load_balancer_arn = "${aws_alb.app-alb.arn}"
  port = 80

  default_action {
    target_group_arn = "${aws_alb_target_group.frontend-target-group.arn}"
    type = "forward"
  }
}
