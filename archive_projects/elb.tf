resource "aws_elb" "elb-terraform" {
  name = "terraform-elb"
  subnets = ["${aws_subnet.public_subnet.id}"]
  security_groups = ["${aws_security_group.sg-web.id}"]
  availability_zones = "${var.azs}"
  
  health_check {
      healthy_threshold = 2
      unhealthy_threshold = 2
      timeout = 3
      interval = 10
      target = "HTTP:8080/index.html"
  }
  
  listener {
      lb_port = 80
      lb_protocol = "http"
      instance_port = "8080"
      instance_protocol = "http"
  }
/*
  instances = "${aws_instance.webserver.id}"
  cross_zone_load_balancing = true
  idle_timeout = 100
  connection_draining = true
  connection_draining_timeout = 300
*/
  tags = {
    Name = "Terraform-ELB"
  }
}

output "elb-dns-name" {
  value = "${aws_elb.elb-terraform.dns_name}"
}