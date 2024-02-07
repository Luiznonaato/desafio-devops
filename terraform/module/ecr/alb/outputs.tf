#Outputs
output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "alb_arn" {
  value = aws_lb.alb.arn
}

output "listener_arn" {
  value = aws_lb_listener.front_end.arn
}
