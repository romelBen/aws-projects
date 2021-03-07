resource "aws_ecs_cluster" "web-cluster" {
    name                    = var.cluster_name
    capacity_providers      = [aws_ecs_capacity_provider.ecs-web.name]
    tags = {
        "env"       = "dev"
        "createdBy" = "romelben"
    }
}

resource "aws_ecs_capacity_provider" "ecs-web" {
    name                    = "capacity-provider-test"
    auto_scaling_group_provider {
        auto_scaling_group_arn          = aws_autoscaling_group.asg.arn
        managed_termination_protection  = "ENABLED"

        managed_scaling {
            status              = "ENABLED"
            target_capacity     = 85
        }
    }
}

# Update file container-def, so it's pulling images from ECR
resource "aws_ecs_task_definition" "ecs-task-definition" {
    family                  = "web-family"
    container_definitions   = file("container-definitions/container-def.json")
    network_mode            = "bridge"
    tags = {
        "env"       = "dev"
        "createdBy" = "romelben"
    }
}

resource "aws_ecs_service" "service" {
    name                    = "web-service"
    cluster                 = aws_ecs_cluster.web-cluster.id
    task_definition         = aws_ecs_task_definition.ecs-task_definition.arn
    desired_count           = 10
    ordered_placement_strategy {
        type    = "binpack"
        field   = "cpu"
    }
    load_balancer {
        target_group_arn    = aws_lb_target_group.lb_target_group.arn
        container_name      = "ecs-group"
        contianer_port      = 80
    }
    # Optional: Allow external changes without Terraform plan difference (for example ASG)
    lifecycle {
        launch_type = [desired_count]
    }
    launch_type = "EC2"
    depends_on  = [aws_lb_listener.web-listener]
}

resource "aws_cloudwatch_log_group" "log_group" {
    name = "/ecs/frontend-container"
    tags = {
        "env"       = "dev"
        "createdBy" = "romelben"
    }
}