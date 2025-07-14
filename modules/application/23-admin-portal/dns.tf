resource "cloudflare_dns_record" "target" {
  depends_on = [aws_apprunner_custom_domain_association.custom_domain]

  zone_id = var.domain.admin.zone_id
  name    = "admin.${var.domain.admin.name}"
  content = aws_apprunner_custom_domain_association.custom_domain.dns_target
  type    = "CNAME"
  ttl     = 1
  proxied = true
  comment = "Admin Portal"
}

resource "cloudflare_dns_record" "certificate_validation" {
  for_each = {
    for record in aws_apprunner_custom_domain_association.custom_domain.certificate_validation_records : record.name => {
      name   = record.name
      record = record.value
      type   = record.type
    }
  }

  zone_id = var.domain.general.zone_id
  name    = each.value.name
  content = each.value.record
  type    = each.value.type
  ttl     = 3600
  proxied = false
  comment = "Admin Portal Certificate Validation"
}

