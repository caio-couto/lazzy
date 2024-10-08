resource "aws_alb" "this" {
  name = local.namespaced_service_name
  subnets = local.subnets.public.id
  security_groups = [aws_security_group.alb.id]
}

resource "aws_alb_target_group" "this" {
  vpc_id = local.vpc.id
  name = local.namespaced_service_name
  port = 80
  protocol = "HTTP"
  target_type = "ip"

  health_check {
    unhealthy_threshold = "2"
    healthy_threshold = "3"
    interval = "30"
    protocol = "HTTP"
    matcher = "200"
    timeout = "3"
    path = "/healthcheck"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.this.id
  port = 80
  protocol = "HTTP"

  dynamic "default_action" {
    for_each = local.has_domain_name ? [1] : []
    content {
      type = "redirect"
      
      redirect {
        protocol = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  }

  dynamic "default_action" {
    for_each = local.has_domain_name ? [0] : [1]
    content {
      type = "forward"
      target_group_arn = aws_alb_target_group.this.id
    }
  }
}

resource "aws_alb_listener" "https" {
  count = local.create_resource_based_on_domain_name
  load_balancer_arn = aws_alb.this.id
  port = 443
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = aws_acm_certificate.this[0].arn

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.this.id
  }

  depends_on = [ aws_acm_certificate_validation.this ]
}