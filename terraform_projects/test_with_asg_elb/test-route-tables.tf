###################### Public Route Table ##############################
resource "aws_route_table" "public_subnet" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
      Name = "Public Subnet RT"
  }
}

resource "aws_route" "public-igw" {
  route_table_id = "${aws_route_table.public_subnet.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.igw.id}"
}

# Route table association
resource "aws_route_table_association" "bastion-association" {
  count = "${length(data.aws_availability_zones.available.names)}"
  subnet_id = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_subnet.id}"
}

##################### Database Route Table ############################
resource "aws_route_table" "database_route" {
  count = "${length(data.aws_availability_zones.available.names)}"
  vpc_id = "${aws_vpc.main.id}"

tags = {
  Name = "Database Route Table-${element(data.aws_availability_zones.available.names, count.index)}"
}
}

resource "aws_route" "database-igw" {
  count = "${length(data.aws_availability_zones.available.names)}"
  route_table_id = "${element(aws_route_table.database_route.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${element(aws_nat_gateway.nat-gw.*.id, count.index)}"
}

# Assign private subnet to private route table
resource "aws_route_table_association" "db-association" {
  count = "${length(var.database_subnet_cidr)}"
  subnet_id = "${element(aws_subnet.database_subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.database_route.*.id, count.index)}"
}

#################### Application Route Table ########################
resource "aws_route_table" "application-rt" {
  count = "${length(data.aws_availability_zones.available.names)}"
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "Application Route Table-${element(data.aws_availability_zones.available.names, count.index)}"
  }
}

resource "aws_route" "application-igw" {
  count = "${length(data.aws_availability_zones.available.names)}"
  route_table_id = "${element(aws_route_table.application-rt.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = "${element(aws_nat_gateway.nat-gw.*.id, count.index)}"
}

resource "aws_route_table_association" "application-association" {
  count = "${length(data.aws_availability_zones.available.names)}"
  subnet_id = "${element(aws_subnet.application_subnet.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.application-rt.*.id, count.index)}"
}