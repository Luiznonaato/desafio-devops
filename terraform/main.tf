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
  ecr_repository_name = ecr_repository_name.default
}
module "ecs" {
  source = "./modules/ecs"
  ami_id = ami_id.default
}
module "route" {
  source = "./modules/route"
}
module "alb" {
  source              = "./modules/alb/"
  /*alb_name            = "meu-alb"
  security_groups     = [module.security_group.sg_id]
  subnets             = module.vpc.subnets
  target_group_name   = "ecs-target-group"
  target_group_port   = 8080
  vpc_id              = module.vpc.vpc_id
  health_check_path   = "/actuator/health"
  health_check_matcher = "200"
  health_check_interval = 30
  health_check_timeout = 5
  health_check_healthy_threshold = 2
  health_check_unhealthy_threshold = 2
  listener_port       = 8080*/
}


