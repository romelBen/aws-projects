
locals {
    userdata-node = <<USERDATA
  #!/bin/bash
  set -o xtrace
  /etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.master-eks.endpoint}' --b64-cluster-ca '${aws_eks_cluster.master-eks.certificate_authority[0].data}' '${var.cluster-name}'
  USERDATA
}


resource "aws_launch_configuration" "eks-launch-config" {
  associate_public_ip_address = true
  iam_instance_profile = "${aws_iam_instance_profile.node.name}" //needs to be worked on
  image_id = "${data.aws_ami.eks-worker.id}" //needs to be worked on
  instance_type = "m3.medium"
  name_prefix = "terraform-eks-launch-config"
  security_groups = "${aws_security_group.eks-node-sg.id}"
  user_data_base64 = "${base64encode(local.userdata-node)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "eks-asg" {
    desired_capacity = 2
    launch_configuration = "${aws_autoscaling_group.eks-asg.id}"
    max_size = 2
    min_size = 1
    name = "Terraform EKS ASG"
    vpc_zone_identifier  = "${aws_subnet.public_subnet.*.id}"

    tag {
        key = "Name"
        value = "terraform-eks-asg"
        propagate_at_launch = true
    }

    tag {
        key = "kubernetes.io/cluster/${var.cluster-name}"
        value = "owned"
        propagate_at_launch = true
    }

}
