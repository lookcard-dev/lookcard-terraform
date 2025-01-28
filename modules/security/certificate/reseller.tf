# resource "aws_acm_certificate" "reseller" {
#   provider = aws.us_east_1
#   domain_name       = "reseller.${var.general_domain}"
#   subject_alternative_names = ["*.reseller.${var.general_domain}"]
#   validation_method = "DNS"
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_route53_record" "reseller" {
#   provider        = aws.dns
#   allow_overwrite = true
#   name            = tolist(aws_acm_certificate.reseller.domain_validation_options)[0].resource_record_name
#   records         = [tolist(aws_acm_certificate.reseller.domain_validation_options)[0].resource_record_value]
#   type            = tolist(aws_acm_certificate.reseller.domain_validation_options)[0].resource_record_type
#   zone_id         = data.aws_route53_zone.general_hosted_zone.zone_id
#   ttl             = 360
# }

# resource "aws_acm_certificate_validation" "reseller" {
#   depends_on              = [aws_acm_certificate.reseller, aws_route53_record.reseller]
#   certificate_arn         = aws_acm_certificate.reseller.arn
#   validation_record_fqdns = [aws_route53_record.reseller.fqdn]
# }