output "lookcard_api_domain" {
  value = aws_api_gateway_domain_name.lookcard_domain.domain_name
}

output "transaction_listener_arm64_asg_arn" {
  value = module.transaction-listener.transaction_listener_arm64_asg_arn
}

output "transaction_listener_amd64_asg_arn" {
  value = module.transaction-listener.transaction_listener_amd64_asg_arn
}