resource "aws_acm_certificate" "this" {
  count = local.create_resource_based_on_domain_name
  domain_name = local.subdomain_name
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "this" {
  count = local.create_resource_based_on_domain_name
  certificate_arn = aws_acm_certificate.this[0].arn 
  validation_record_fqdns = [ for record in aws_route53_record.cert_validation : record.fqdn ]
}