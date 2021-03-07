# Define security group for public subnet
resource "aws_security_group" "sql-sg" {
  vpc_id = "${aws_vpc.main.id}"
  name = "SQL-SG"
  description = "Allow incoming HTTP connections & SSH access"

  ingress {
    from_port = 3389
    to_port = 3389
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 1433
    to_port = 1433
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Microsoft SQL Server SG"
  }
}