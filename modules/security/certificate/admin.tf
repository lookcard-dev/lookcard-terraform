# resource "aws_acm_certificate" "admin" {
#   provider = aws.us_east_1
#   domain_name       = "admin.${var.admin_domain}"
#   subject_alternative_names = ["*.admin.${var.admin_domain}"]
#   validation_method = "DNS"
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_route53_record" "admin" {
#   provider        = aws.dns
#   allow_overwrite = true
#   name            = tolist(aws_acm_certificate.admin.domain_validation_options)[0].resource_record_name
#   records         = [tolist(aws_acm_certificate.admin.domain_validation_options)[0].resource_record_value]
#   type            = tolist(aws_acm_certificate.admin.domain_validation_options)[0].resource_record_type
#   zone_id         = data.aws_route53_zone.admin_hosted_zone.zone_id
#   ttl             = 360
# }

# resource "aws_acm_certificate_validation" "admin" {
#   depends_on              = [aws_acm_certificate.admin, aws_route53_record.admin]
#   certificate_arn         = aws_acm_certificate.admin.arn
#   validation_record_fqdns = [aws_route53_record.admin.fqdn]
# }