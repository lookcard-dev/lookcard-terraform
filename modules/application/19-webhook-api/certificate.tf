resource "aws_acm_certificate" "certificate" {
  domain_name       = "webhook.${var.general_domain}"
  validation_method = "DNS"
  provider          = aws.us_east_1
  lifecycle {
    create_before_destroy = true
  }
}