variable "ami_id" {
  type    = string
  default = file("${path.modules}/../variables.tf")
}
