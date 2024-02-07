
# Outputs
output "subnet_id" {
  value = aws_subnet.subnet_id.id
}

output "vpc_id" {
  value = aws_vpc.meu_vpc.id
}