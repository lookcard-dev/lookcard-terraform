resource "aws_acm_certificate" "certificate" {
  domain_name       = "webhook.${var.domain.general.name}"
  validation_method = "DNS"
  provider          = aws.us_east_1
  lifecycle {
    create_before_destroy = true
  }
}