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
}
module "ecs" {
  source = "./modules/ecs"
  ami_id = ami_id.default
}
module "route" {
  source = "./modules/route"
}
module "alb" {
  source = "./modules/alb/"
  security_groups = [module.security_group.security_group_id]
  subnets         = [module.subnet.subnet_id] // Isso supõe que você tenha um módulo para subnet com um output `subnet_id`
}


