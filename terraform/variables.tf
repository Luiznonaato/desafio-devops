variable "AWS_DEFAULT_REGION" {
  description = "Regiao"
  type        = string
}

variable "vpc_id" {
  description = "O ID da VPC"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de IDs das subnets para o ALB e instâncias EC2"
  type        = list(string)
}

variable "ami_id" {
  description = "AMI ID para as instâncias EC2"
  type        = string
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
