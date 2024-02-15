//VPC
module "vpc" {
  source = "./modules/vpc"
}

module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

module "ecs" {
  source = "./modules/ecs"
  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.subnet_id
  aws_security_group = [module.sg.aws_security_group]
  aws_lb_target_group = module.alb.aws_lb_target_group
  alb_arn = module.alb.alb_arn
  aws_lb_listener = [module.alb.aws_lb_listener]
}

module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.subnet_id
  aws_security_group = [module.sg.aws_security_group]
  aws_autoscaling_group = module.ecs.aws_autoscaling_group
  AWS_DEFAULT_REGION = var.AWS_DEFAULT_REGION
}
