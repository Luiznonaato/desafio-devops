
#Outputs
output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.meu_task_definition.arn
}

output "ecs_service_name" {
  value = aws_ecs_service.meu_servico_ecs.name
}

output "launch_template_id" {
  value = aws_launch_template.ecs_launch_template.id
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.ecs_asg.name
}
