# Criação da VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Subnet
resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "${var.project_name}-subnet"
  }
}

# Gateway da Internet
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Tabela de Rotas
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "${var.project_name}-route-table"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

# Instância EC2
resource "aws_instance" "my_instance" {
  ami           = "ami-0c02fb55956c7d316" # Ubuntu Server 20.04 LTS (ami pode variar por região)
  instance_type = var.instance_type
  subnet_id     = aws_subnet.my_subnet.id

  tags = {
    Name = "${var.project_name}-instance"
  }
}

