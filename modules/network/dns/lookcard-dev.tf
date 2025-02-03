resource "aws_route53_record" "lookcard_dev_txt" {
  provider = aws.dns
  zone_id = data.aws_route53_zone.lookcard_dev.zone_id
  name    = "lookcard.dev"
  type    = "TXT"
  ttl     = "300"
  records = ["MS=ms62500152", "v=spf1 include:spf.protection.outlook.com -all"]
}

resource "aws_route53_record" "lookcard_dev_microsoft365_mx" {
  provider = aws.dns
  zone_id = data.aws_route53_zone.lookcard_dev.zone_id
  name    = "lookcard.dev"
  type    = "MX"
  ttl     = "3600"
  records = ["0 lookcard-dev.mail.protection.outlook.com"]
}

resource "aws_route53_record" "lookcard_dev_microsoft365_autodiscover" {
  provider = aws.dns
  zone_id = data.aws_route53_zone.lookcard_dev.zone_id
  name    = "autodiscover.lookcard.dev"
  type    = "CNAME"
  ttl     = "3600"
  records = ["autodiscover.outlook.com."]
}

