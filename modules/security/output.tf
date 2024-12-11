# waf
output "portal_waf" {
  value = module.waf.portal_waf
}

output "api_waf" {
  value = module.waf.api_waf
}

output "webhook_waf" {
  value = module.waf.webhook_waf
}