variable "ecr_repository_name" {
  type    = string
  default = file("${path.module}/../variables.tf")
}

variable "ami_id" {
  type    = string
  default = file("${path.module}/../variables.tf")
}
