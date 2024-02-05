variable "instance_type" {
  description = "Tipo de instância EC2"
  default     = "t2.micro"
}

variable "project_name" {
  description = "Desafio-devops"
  default     = "Desafio-devops"
}

variable "region" {
  description = "A região da AWS onde os recursos serão criados"
  default     = "us-east-1"
}