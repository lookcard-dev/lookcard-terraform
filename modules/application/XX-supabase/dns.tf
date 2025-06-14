# resource "cloudflare_dns_record" "api" {
#   zone_id = var.domain.general.zone_id
#   name    = "supabase.${var.domain.general.name}"
#   content = aws_api_gateway_domain_name.supabase_domain.cloudfront_domain_name
#   type    = "CNAME"
#   ttl     = 1
#   proxied = true
#   depends_on = [
#     aws_api_gateway_domain_name.supabase_domain
#   ]
# }

# resource "cloudflare_dns_record" "studio" {
#   zone_id = var.domain.admin.zone_id
#   name    = "studio.supabase.${var.domain.admin.name}"
#   content = aws_apprunner_custom_domain_association.studio_domain.dns_target
#   type    = "CNAME"
#   ttl     = 1
#   proxied = true

#   depends_on = [
#     aws_apprunner_custom_domain_association.studio_domain
#   ]
# }

# resource "cloudflare_dns_record" "studio_certificate_validation" {
#   for_each = {
#     for record in aws_apprunner_custom_domain_association.studio_domain.certificate_validation_records : record.name => {
#       name   = record.name
#       record = record.value
#       type   = record.type
#     }
#   }

#   zone_id = var.domain.admin.zone_id
#   name    = each.value.name # Use the name directly as it's already a full FQDN
#   content = each.value.record
#   type    = each.value.type
#   ttl     = 3600
#   proxied = false
# }

# output "dns_records" {
#   value = {
#     public_api = {
#       domain = "supabase.${var.domain.general.name}"
#       type   = "CNAME (Cloudflare Proxied)"
#       target = aws_api_gateway_domain_name.supabase_domain.cloudfront_domain_name
#       ssl    = "Cloudflare Certificate Pack"
#     }
#     admin_studio = {
#       domain = "studio.supabase.${var.domain.admin.name}"
#       type   = "CNAME (Cloudflare Proxied)"
#       target = aws_apprunner_custom_domain_association.studio_domain.dns_target
#       ssl    = "Managed by App Runner automatically"
#     }
#   }
#   description = "Cloudflare DNS records for Supabase services"
# }
