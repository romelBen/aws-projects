resource "aws_vpc" "eks-vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"

  tags = {
      "Name" = "terraform-eks-vpc"
      "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

resource "aws_subnet" "eks-subnets" {
  count = "${length(data.aws_availability_zones.avaiable.names)}"
  vpc_id = "${aws_vpc.eks-vpc.id}"
  cidr_block = "${element(var.public_subnet_cidr, count.index)}"
  availability_zone = "${data.aws_availability_zones.avaiable.names[count.index]}"

  tags = {
      "Name" = "terraform-eks-vpc"
      "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}

resource "aws_internet_gateway" "eks-igw" {
  vpc_id = "${aws_vpc.eks-vpc.id}"

  tags = {
      Name = "terraform-eks-igw"
  }
}

resource "aws_route_table" "eks-rt" {
  vpc_id = "${aws_vpc.eks-vpc.id}"
  
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.eks-igw.id}"
  }
}

resource "aws_route_table_association" "eks-association" {
   count = "${length(var.public_subnet_cidr)}"
   subnet_id = "${element(aws_subnet.eks-subnets.*.id, count.index)}"
   route_table_id = "${aws_route_table.eks-rt.id}"
}

