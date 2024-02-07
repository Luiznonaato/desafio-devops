# Application Load Balancer
variable "security_groups" {
  description = "List of security group IDs to associate with the ALB"
  type        = list(string)
}

variable "vpc" {
  description = "List of subnet IDs to associate with the ALB"
  type        = list(string)
}

resource "aws_lb" "alb" {
  name               = "meu-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups.security_group_id
  subnets            = var.vpc.subnet_id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
  }
}

