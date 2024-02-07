module "vpc" {
  source     = "./modules/vpc"
  vpc_id     = var.vpc_id 
  subnet_id  = aws_subnet.subnet_id.id
}
