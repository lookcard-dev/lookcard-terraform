
# app.test.lookcard.io
# resource "aws_acm_certificate" "app" {
#   domain_name       = var.app_hostname
#   validation_method = "DNS"
#   provider          = aws.east

#   lifecycle {
#     create_before_destroy = true
#   }
# }
# resource "aws_route53_record" "lookcard_certs" {
#   provider        = aws.east
#   allow_overwrite = true
#   name            = tolist(aws_acm_certificate.app.domain_validation_options)[0].resource_record_name
#   records         = [tolist(aws_acm_certificate.app.domain_validation_options)[0].resource_record_value]
#   type            = tolist(aws_acm_certificate.app.domain_validation_options)[0].resource_record_type
#   zone_id         = data.aws_route53_zone.hosted_zone_id.zone_id
#   ttl             = 60
# }

# resource "aws_acm_certificate_validation" "lookcard_validation" {
#   provider                = aws.east
#   certificate_arn         = aws_acm_certificate.app.arn
#   validation_record_fqdns = [aws_route53_record.lookcard_certs.fqdn]
# }
