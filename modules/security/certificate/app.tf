# resource "aws_acm_certificate" "app" {
#   provider = aws.us_east_1
#   domain_name       = "${var.general_domain}"
#   subject_alternative_names = ["*.${var.general_domain}"]
#   validation_method = "DNS"
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_route53_record" "app" {
#   provider        = aws.dns
#   allow_overwrite = true
#   name            = tolist(aws_acm_certificate.app.domain_validation_options)[0].resource_record_name
#   records         = [tolist(aws_acm_certificate.app.domain_validation_options)[0].resource_record_value]
#   type            = tolist(aws_acm_certificate.app.domain_validation_options)[0].resource_record_type
#   zone_id         = data.aws_route53_zone.general_hosted_zone.zone_id
#   ttl             = 360
# }

# resource "aws_acm_certificate_validation" "app" {
#   depends_on              = [aws_acm_certificate.app, aws_route53_record.app]
#   certificate_arn         = aws_acm_certificate.app.arn
#   validation_record_fqdns = [aws_route53_record.app.fqdn]
# }