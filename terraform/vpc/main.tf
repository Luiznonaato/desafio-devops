# VPC
resource "aws_vpc" "meu_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "MinhaVPC"
  }
}

# Subnet
resource "aws_subnet" "subnet_id" {
  vpc_id            = aws_vpc.meu_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet_id"
  }
}

# Outputs
output "subnet_id" {
  value = aws_subnet.subnet_id.id
}

output "vpc_id" {
  value = aws_vpc.meu_vpc.id
}