 provider "aws" {
  region = var.AWS_DEFAULT_REGION
}

resource "aws_lb" "bluesoft" {
  name            = var.lb_name
  internal        = var.internal
  security_groups = var.aws_security_group
  subnets         = var.subnet_id

  // Se for um ALB público, descomente a próxima linha
  load_balancer_type = "application"
    tags = {
    Name = "lb-${var.lb_name}"
  }
}

resource "aws_lb_listener" "bluesoft" {
  load_balancer_arn = aws_lb.bluesoft.arn
  protocol         = var.protocol
  port             = var.port

  default_action {
    target_group_arn = aws_lb_target_group.bluesoft.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "bluesoft" {
  name     = var.lb_name
  port     = var.port
  protocol = var.protocol
  vpc_id   = var.vpc_id

  health_check {
    path                = var.health_check_path
    timeout             = var.health_check_timeout
    interval            = var.health_check_interval
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
  }
  tags = {
    Name = "tg-${var.lb_name}"
  }
}

/*
resource "aws_acm_certificate" "bluesoft" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Name = "cert-${var.domain_name}"
  }
}

resource "aws_acm_certificate_validation" "bluesoft" {
  certificate_arn         = aws_acm_certificate.bluesoft.arn
  validation_record_fqdns = [aws_route53_record.bluesoft_validation.fqdn]
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.bluesoft.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bluesoft.arn
  }

  certificate_arn = aws_acm_certificate.bluesoft.arn
}

resource "aws_route53_record" "bluesoft_validation" {
  // Definição do Route 53 record para validação do certificado
}
*/
