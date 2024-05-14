output "acm_app" {
  value = aws_acm_certificate.app
}


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
