# EKS Worker Node Resource
# * IAM role allowing Kubernetes actions to access other AWS services
# * EKS Node Group to launch worker nodes

resource "aws_iam_role" "iam-worker" {
  name = "Terraform EKS Worker"

  assume_role_policy = <<POLICY
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Principal": {
                  "Service": "ec2.amazonaws.com"
              },
          }
          "Action": "sts:AssumeRole"
      ]
  }
  POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = "${aws_iam_role.iam-worker.name}"
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = "${aws_iam_role.iam-worker.name}"
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = "${aws_iam_role.iam-worker.name}"
}

resource "aws_eks_node_group" "eks-node" {
  cluster_name = "${aws_eks_cluster.master-eks.name}"
  node_group_name = "node-test"
  node_role_arn = "${aws_iam_role.iam-worker.arn}"
  subnet_ids = "${aws_subnet.demo.*.id}"

  scaling config {
    desired_size = 1
    max_size = 1
    min_size = 1
  }
}

