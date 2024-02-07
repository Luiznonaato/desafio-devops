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
  value = var.ami_id.id
}