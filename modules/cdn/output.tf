output "reseller_portal" {
  value = {
    arn = aws_cloudfront_distribution.reseller_portal.arn
  }
}
