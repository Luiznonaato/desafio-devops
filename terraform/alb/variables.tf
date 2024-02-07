variable "alb_name" {}
variable "security_groups" {
  type = list(string)
}
variable "subnets" {
  type = list(string)
}
variable "target_group_name" {}
variable "target_group_port" {
  type = number
}
variable "vpc_id" {}
variable "health_check_path" {}
variable "health_check_matcher" {}
variable "health_check_interval" {
  type = number
}
variable "health_check_timeout" {
  type = number
}
variable "health_check_healthy_threshold" {
  type = number
}
variable "health_check_unhealthy_threshold" {
  type = number
}
variable "listener_port" {
  type = number
}
