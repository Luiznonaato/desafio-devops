module "vpc" {
  source = "./modules/vpc"
  // Parâmetros para o módulo VPC
}
module "security_group" {
  source = "./modules/security_group"
  // Parâmetros para o módulo Security Group
}
module "ecr" {
  source = "./modules/ecr"
  ami_id = "ami-0277155c3f0ab2930"
  vpc    = [module.vpc.vpc_id]
}
module "ecs" {
  source = "./modules/ecs"
  ami_id = "ami-0277155c3f0ab2930"
  vpc    = [module.vpc.meu_vpc]
}
module "route" {
  source = "./modules/route"
}
module "alb" {
  source          = "./modules/alb/"
  security_groups = [module.security_group]
  vpc             = [module.vpc.subnet_id]
}
