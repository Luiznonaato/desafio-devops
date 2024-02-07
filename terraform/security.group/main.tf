# Security Group para o ALB e ECS
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.meu_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#output
output "security_group_id" {
  value = aws_security_group.sg.id
}
