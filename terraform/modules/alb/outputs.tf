#Outputs

output "alb_dns_name" {
  value = aws_lb.bluesoft.dns_name
}

output "alb_arn" {
  value = aws_lb.bluesoft.arn
}
/*
output "aws_autoscaling_group" {
  value = aws_autoscaling_group.main.id
}*/

output "aws_lb_target_group" {
  value = aws_lb_target_group.bluesoft.id
}

output "aws_lb_listener" {
  value = aws_lb_listener.bluesoft.id
}