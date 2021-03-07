resource "aws_route_table" "public_subnet" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name = "Public Subnet RT"
  }
}

# Assign public subnet to public route table 
resource "aws_route_table_association" "web-public-association" {
  #count = "${length(var.public_subnet_cidr)}"
  #subnet_id = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  subnet_id      = "${aws_subnet.public_subnet.id}"
  route_table_id = "${aws_route_table.public_subnet.id}"
}

/*
resource "aws_route_table" "private_subnet" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.nat-gw.id}"
  }

  tags = {
    Name = "Private Subnet RT"
  }
}

# Assign private subnet to private route table
resource "aws_route_table_association" "db-private-association" {
  #count = "${length(var.private_subnet_cidr)}"
  #subnet_id = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  subnet_id      = "${aws_subnet.private_subnet.id}"
  route_table_id = "${aws_route_table.private_subnet.id}"
}
*/
