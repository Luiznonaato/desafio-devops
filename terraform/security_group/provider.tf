provider "AWS_DEFAULT_REGION" {
  region = var.AWS_DEFAULT_REGION
  default = file("${path.module}/../provider.tf")
}
