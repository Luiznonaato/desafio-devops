#Repositorio
variable "vpc" {
  description = "List of subnet IDs to associate with the ALB"
  type        = list(string)
}


resource "aws_ecr_repository" "repositorio" {
  name                 = var.ecr_repository_name
  image_tag_mutability = "MUTABLE"
}

resource "aws_lb_target_group" "ecs_target_group" {
  name     = "ecs-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc.meu_vpc.meu_vpc.id

  health_check {
    enabled             = true
    path                = "/actuator/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_instance" "ami_id" {
  ami           = var.ami_id
  instance_type = "t2.micro"
}