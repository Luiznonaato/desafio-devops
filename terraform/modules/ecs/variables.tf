variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado"
  type        = string
}

variable "environment" {
  description = "Environment tag."
  type        = string
  default = "environment"
}

variable "use_AmazonEC2ContainerServiceforEC2Role_policy" {
  description = "Attaches the AWS managed AmazonEC2ContainerServiceforEC2Role policy to the ECS instance role."
  type        = string
  default     = true
}

variable "instance_type" {
  description = "The instance type to use."
  type        = string
  default     = "t2.micro"
}

data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }
}

variable "aws_security_group" {
  description = "ID d§a VPC onde o Security Group será criado"
  type = list(string)
}

variable "subnet_id" {
  description = "Subnet"
  type = list(string)
}

variable "desired_capacity" {
  description = "Desired instance count."
  type        = string
  default     = 1
}

variable "max_size" {
  description = "Maxmimum instance count."
  type        = string
  default     = 3 
}

variable "min_size" {
  description = "Minimum instance count."
  type        = string
  default     = 1
}

variable "aws_lb_target_group" {
  description = "ALB Target Group"
  type = string
}

variable "alb_arn" {
  description = "ALB arn"
  type = string
}

variable "aws_lb_listener" {
  description = "Listener"
  type = list(string)
}