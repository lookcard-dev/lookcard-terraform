resource "aws_route53_record" "lookcard_org_txt" {
  provider = aws.dns
  zone_id  = data.aws_route53_zone.lookcard_org.zone_id
  name     = "lookcard.org"
  type     = "TXT"
  ttl      = "300"
  records  = ["MS=ms68949253", "v=spf1 include:spf.protection.outlook.com -all"]
}

resource "aws_route53_record" "lookcard_org_microsoft365_mx" {
  provider = aws.dns
  zone_id  = data.aws_route53_zone.lookcard_org.zone_id
  name     = "lookcard.org"
  type     = "MX"
  ttl      = "3600"
  records  = ["0 lookcard-org.mail.protection.outlook.com"]
}

resource "aws_route53_record" "lookcard_org_microsoft365_autodiscover" {
  provider = aws.dns
  zone_id  = data.aws_route53_zone.lookcard_org.zone_id
  name     = "autodiscover.lookcard.org"
  type     = "CNAME"
  ttl      = "3600"
  records  = ["autodiscover.outlook.com."]
}

