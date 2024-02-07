variable "ecr_repository_name" {
  type    = string
  default = file("${path.modules}/../variables.tf")
}

variable "ami_id" {
  type    = string
  default = file("${path.modules}/../variables.tf")
}
