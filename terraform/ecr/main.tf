#Repositorio
resource "aws_ecr_repository" "repositorio" {
  name                 = var.ecr_repository_name
  image_tag_mutability = "MUTABLE"
}
output "ecr_repository_url" {
  value = aws_ecr_repository.repositorio.repository_url
}

resource "aws_lb_target_group" "ecs_target_group" {
  name     = "ecs-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.meu_vpc.id

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

#Outputs
output "ecr_repository_url" {
  value = aws_ecr_repository.repositorio.repository_url
}

output "ecs_target_group_arn" {
  value = aws_lb_target_group.ecs_target_group.arn
}

output "instance_id" {
  value = aws_instance.ami_id.id
}

output "ami_id" {
  value = var.ami_id
}
