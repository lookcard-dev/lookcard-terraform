# resource "cloudflare_dns_record" "general_dns_record" {
#   zone_id = var.domain.general.zone_id
#   name    = "auth.${var.domain.general.name}"
#   content = aws_api_gateway_domain_name.domain.cloudfront_domain_name
#   type    = "CNAME"
#   ttl     = 1
#   proxied = true
#   comment = "FusionAuth"
# }

# resource "cloudflare_dns_record" "certificate_validation" {
#   for_each = {
#     for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }
#   zone_id = var.domain.general.zone_id
#   name    = each.value.name # Use the name directly as it's already a full FQDN
#   content = each.value.record
#   type    = each.value.type
#   ttl     = 3600
#   proxied = false
#   comment = "FusionAuth Certificate Validation"
# }

# # Wait for certificate validation to complete
# resource "aws_acm_certificate_validation" "certificate_validation" {
#   provider                = aws.us_east_1
#   certificate_arn         = aws_acm_certificate.certificate.arn
#   validation_record_fqdns = [for record in cloudflare_dns_record.certificate_validation : record.name]
# }
