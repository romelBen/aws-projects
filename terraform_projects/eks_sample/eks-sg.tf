# EKS Cluster Security Group
resource "aws_security_group" "eks-cluster-sg" {
  name = "Terraform EKS Cluster SG"
  description = "Cluster communication with worker nodes"
  vpc_id = "${aws_vpc.demo.id}"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
      Name = "Terraform-EKS-Cluster-SG"
  }
}

# EKS Node Security Group
resource "aws_security_group" "eks-node-sg" {
  name = "Terraform EKS Node SG"
  description = "Security group for all nodes in the cluster"
  vpc_id = "${aws_vpc.eks-vpc.id}"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "terraform-eks-node"
    "kubernetes.io/cluster/${var.cluster-name}" = "owned"
  }
}

# Security group rule allowing node communication
resource "aws_security_group_rule" "node-ingress-sg-self" {
  description = "Allow node to communicate with each other"
  from_port = 0
  protocol = "-1"
  security_group_id = "${aws_security_group.eks-node-sg.id}" 
  source_security_group_id = "${aws_security_group.eks-node-sg.id}"
  to_port = 65535
  type = "ingress"
}

# Security group rule to allow Kubelets and pods to communicate
resource "aws_security_group_rule" "node-ingress-sg-cluster" {
  description = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port = 1025
  protocol = "tcp"
  security_group_id = "${aws_security_group.eks-node-sg.id}" 
  source_security_group_id = "${aws_security_group.eks-cluster-sg}"
  to_port = 65535
  type = "ingress" 
}

# Security group rule for communication with cluster API server
resource "aws_security_group_rule" "ingress-workstation-https" {
    cidr_block = "70.121.117.248/32"
    description = "Allow workstation to communicate with the cluster API Server"
    from_port = 443
    protocol = "tcp"
    security_group_id = "${aws_security_group.eks-sg.id}"
    to_port = 443
    type = "ingress"
}

# Security group rule to communicate with pods
resource "aws_security_group_rule" "ingress-node-https" {
  description = "Allow pods to communicate with the cluster API server"  
  from_port = 443
  protocol = "tcp"
  security_group_id = "${aws_security_group.eks-cluster-sg.id}"
  source_security_group_id = "${aws_security_group.eks-node-sg.id}"
  to_port = 443
  type = "ingress"
}