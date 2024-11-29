# output "lookcard_api_domain" {
#   value = aws_api_gateway_domain_name.lookcard_domain.domain_name
# }

output "ecr_repository_urls" {
  value = { for key, repo in aws_ecr_repository.look-card : key => repo.repository_url }
}

# For api_gw
output "nlb" {
  value = {
    arn = aws_lb.nlb.arn
  }
}

output "alb_lookcard" {
  value = {
    dns_name = aws_alb.look-card.dns_name
  }
}

output "lambda_function_sumsub_webhook" {
  value = {
    invoke_arn = module.sumsub-webhook.sumsub_webhook.invoke_arn
  }
}

output "lambda_function_firebase_authorizer" {
  value = {
    arn = module.firebase-authorizer.lambda_firebase_authorizer.arn
    invoke_arn = module.firebase-authorizer.lambda_firebase_authorizer.invoke_arn
  }
}