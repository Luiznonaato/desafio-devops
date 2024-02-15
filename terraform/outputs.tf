output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "O ID da VPC criada pelo módulo VPC"
}

output "subnet_id" {
  value       = module.vpc.subnet_id
  description = "O ID da VPC criada pelo módulo VPC"
}

output "AWS_DEFAULT_REGION" {
  value       = var.AWS_DEFAULT_REGION
  description = "O ID da VPC criada pelo módulo VPC"
}