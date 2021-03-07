resource "aws_ecs_cluster" "main_cluster" {
  name = "Main Cluster"
}

resource "aws_launch_configuration" "main-ecs-launchconfig" {
  name_prefix = "ECS Launch Configuration"
  image_id = "${var.ECS_AMIS[var.AWS_REGION]}"
  instance_type = "t2.small"
  key_name = "${var.AWS_KEY_NAME}"
  iam_instance_profile = "${}"
}