output "vpc_id" {
  value       = aws_vpc.main.id
  description = "O ID da VPC criada"
}

output "subnet_id" {
  value = aws_subnet.public_subnets.*.id
}
