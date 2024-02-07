


/*

# Data source para a zona do Route53
data "aws_route53_zone" "selected" {
  name = var.zone_name
}

# Recurso para o registro no Route53
resource "aws_route53_record" "desafio_devops" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

*/