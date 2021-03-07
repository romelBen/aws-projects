# This will contain 3 AWS Services:
# * IAM Role to allow EKS service to manage other AWS services
# * EC2 Security Group to allow networking traffic with EKS cluster
# * EKS Cluster

resource "aws_eks_cluster" "master-eks" {
  name = "${var.cluster-name}"
  role_arn = "${aws_iam_role.iam-cluster.arn}"

  vpc_config {
    count = "${length(var.public_subnet_cidr)}"
    subnet_ids = "${element(aws_subnet.public_subnet.*.id, count.index)}"
    security_group_ids = ["${aws_security_group.eks-sg.id}"]
  }

    depends_on = [
        "aws_iam_role_policy_attachment.AmazonEKSClusterPolicy",
        "aws_iam_role_policy_attachment.AmazonEKSServicePolicy"
    ]
}

resource "aws_iam_role" "iam-cluster" {
  name = "Terraform EKS Cluster"

  assume_role_policy = <<POLICY
  {
      "Version" = 2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Principal": {
                  "Service": "eks.amazonaws.com"
              },
              "Action": "sts:AssumeRole"
          }
      ]
  }
  POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = "${aws_iam_role.iam-cluster.name}"
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role = "${aws_iam_role.iam-cluster.name}"
}
