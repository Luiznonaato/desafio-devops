variable "AWS_DEFAULT_REGION" {
  description = "Regiao"
  type        = string
  default     = "us-east-1"
}


variable "vpc_id" {
  description = "O ID da VPC"
  type        = string
}

variable "subnet_id_a" {
  description = "subnet"
  type        = string
  default     = "subnetid"
}

variable "ami_id" {
  description = "AMI ID para as instâncias EC2"
  type        = string
  default     = "ami-0277155c3f0ab2930"  
}


variable "app_dns_name" {
  description = "O nome DNS para o registro no Route53 apontando para o ALB"
  type        = string
  default     = "app.bluesoft.com.br"
}

variable "zone_name" {
  description = "O nome da zona DNS no Route53."
  type        = string
  default     = "bluesoft.com.br."
}

variable "record_name" {
  description = "O nome do registro DNS no Route53 para a aplicação."
  type        = string
  default     = "desafio-devops.bluesoft.com.br"
}

variable "ecr_repository_name" {
  description = "O nome do repositório ECR."
  type        = string
  default     = "repositorio" 
}

