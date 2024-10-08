data "aws_route53_zone" "this" {
  count = local.create_resource_based_on_domain_name
  name = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "api" {
  count = local.create_resource_based_on_domain_name
  name = local.subdomain_name
  type = "A"
  zone_id = data.aws_route53_zone.this[0].zone_id

  alias {
    evaluate_target_health = false
    name = aws_alb.this.dns_name
    zone_id = aws_alb.this.zone_id
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = local.has_domain_name ? {
    for dvo in aws_acm_certificate.this[0].domain_validation_options : dvo.domain_name => {
      name = dvo.resource_record_name
      record = dvo.resource_record_value
      type = dvo.resource_record_type
    }
  } : {}

  allow_overwrite = false 
  name = each.value.name
  type = each.value.type
  records = [each.value.record]
  zone_id = data.aws_route53_zone.this[0].zone_id 
  ttl = 60
}