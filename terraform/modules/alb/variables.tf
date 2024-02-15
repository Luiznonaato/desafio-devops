variable "AWS_DEFAULT_REGION" {
  description = "Regiao"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado"
  type        = string
}

variable "aws_security_group" {
  description = "ID d§a VPC onde o Security Group será criado"
  type = list(string)
}

variable "subnet_id" {
  description = "Subnet"
  type = list(string)
}

variable "lb_name" {
  description = "Name of the load balancer"
  default = "lbblue"
}

variable "internal" {
  description = "Is the load balancer internal"
  default     = false
}

variable "protocol" {
  description = "The protocol for the listener"
  default     = "HTTP"
}

variable "port" {
  description = "The port for the listener"
  default     = 8080
}

variable "aws_autoscaling_group" {
  description = "The name for the target group"
  type = string
}

variable "health_check_path" {
  description = "The health check path"
  default     = "/health"
}

variable "health_check_timeout" {
  description = "The health check timeout"
  default     = 5
}

variable "health_check_interval" {
  description = "The health check interval"
  default     = 30
}

variable "healthy_threshold" {
  description = "The healthy threshold"
  default     = 2
}

variable "unhealthy_threshold" {
  description = "The unhealthy threshold"
  default     = 2
}

/*
variable "domain_name" {
  description = "The domain name for the SSL certificate"
}*/