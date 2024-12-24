# output "acm_app" {
#   value = aws_acm_certificate.app
# }


# output "acm_certificate_arn" {
#   value = aws_acm_certificate_validation.lookcard_validation.certificate_arn
# }

# output "Hosted_Zone_ID" {
#   value = data.aws_route53_zone.production.zone_id
# }

# output "admin_panel_acm_certificate_arn" {
#   value = aws_acm_certificate_validation.admin_panel_validation.certificate_arn

# }

# output "Api_hosted_Zone_ID" {
#   value = data.aws_route53_zone.production_api.zone_id
# }

# output "admin_panel_zone_id" {
#   value = aws_route53_zone.production_admin_panel.zone_id

# }

output "cert_api_arn" {
  value = aws_acm_certificate.api.arn
}

output "domain_api_name" {
  value = aws_acm_certificate.api.domain_name
}

# output "reseller_portal" {
#   value = {
#     cert_arn = aws_acm_certificate.reseller_portal.arn
#     domain_name = aws_acm_certificate.reseller_portal.domain_name
#   }
# }

output "reseller_api" {
  value = {
    cert_arn = aws_acm_certificate.reseller_api.arn
    domain_name = aws_acm_certificate.reseller_api.domain_name
  }
}

output "webhook" {
  value = {
    cert_arn = aws_acm_certificate.webhook.arn
    domain_name = aws_acm_certificate.webhook.domain_name
  }
}