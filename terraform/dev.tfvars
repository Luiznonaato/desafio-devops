module "vpc" {
  source = "./modules/vpc"
  vpc_id = var.vpc_id 
  value  = aws_subnet.subnet_id.id
}
