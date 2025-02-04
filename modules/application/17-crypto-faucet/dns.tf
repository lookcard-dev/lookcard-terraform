data "aws_route53_zone" "zone" {
  name = "lookcard.dev"
  provider = aws.dns
}

data "aws_apprunner_hosted_zone_id" "main" {}

resource "aws_route53_record" "target" {
  provider = aws.dns
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "faucet.lookcard.dev"
  type    = "A"

  alias {
    name                   = aws_apprunner_custom_domain_association.custom_domain.dns_target
    zone_id               = data.aws_apprunner_hosted_zone_id.main.id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "certificate_validation" {    
  provider = aws.dns
  for_each = {
    for record in aws_apprunner_custom_domain_association.custom_domain.certificate_validation_records : record.name => {
      name   = record.name
      record = record.value
      type   = record.type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 300
  type            = each.value.type
  zone_id         = data.aws_route53_zone.zone.zone_id
}

