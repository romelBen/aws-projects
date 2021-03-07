output "instance_ids" {
  value = ["${aws_instance.webserver.*.public_ip}"]
}

output "elb_dns_name" {
  value = "${aws_elb.elb-demo.dns_name}"
}