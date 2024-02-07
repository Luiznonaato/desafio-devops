variable "ami_id" {
  type    = string
  default = file("${path.module}/../variables.tf")
}
