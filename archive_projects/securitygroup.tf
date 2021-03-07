data "aws_ip_ranges" "us_ec2" {
    regions = [ "us-east-1", "us-east-2" ]
    services = [ "ec2" ]
}

resource "aws_security_group" "allow-ssh" {
  vpc_id = "${aws_vpc.main.id}"
  name = "allow-ssh"
  description = "security group that allows ssh and ALL egress traffic"

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-ssh"
  }
}

/* # Security group created to ALLOW ingress traffic of 443 (HTTPS)
resource "aws_security_group" "from_us" {
 name = "from_us"

  ingress {
    from_port = "443"
    to_port = "443"
    protocol = "tcp"
    cidr_blocks = "${data.aws_ip_ranges.us_ec2.cidr_blocks}" 
  }
  tags = {
    CreateDate = "${data.aws_ip_ranges.us_ec2.create_date}"
    SyncToken = "${data.aws_ip_ranges.us_ec2.sync_token}"
  }
}
*/

