resource "aws_lb" "ecs-lb" {
    name                = "ecs-lb"
    load_balancer_type  = "application"
    internal            = false
    subnets             = module.vpc.public_subnets
    security_groups     = [aws_security_group.ecs-lb.id]
    tags = {
        "env"       = "dev"
        "createdBy" = "romelben"
    }
}

resource "aws_lb_target_group" "lb_target_group" {
    name                = "ecs-target-group"
    port                = "80"
    protocol            = "HTTP"
    target_type         = "instance"
    vpc_id              = data.aws_vpc.id
    health_check {
        path                = "/"
        healthy_threshold   = 2
        unhealthy_threshold = 10
        timeout             = 60
        interval            = 300
        matcher             = "200, 301, 302"
    }
}

resource "aws_lb_listener" "web-listener" {
    load_balancer_arn   = aws_lb.ecs-lb.arn
    port                = "80"
    protocol            = "HTTP"
    default_action {
        type                = "forward"
        target_group_arn    = aws_lb_target_group.lb_target_group.arn
    }
}