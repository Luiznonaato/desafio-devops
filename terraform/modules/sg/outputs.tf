output "aws_security_group" {
  value       = aws_security_group.bluesoft_security_group.id
  description = "ID SG"
}