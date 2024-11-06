output "lookcard_api_domain" {
  value = aws_api_gateway_domain_name.lookcard_domain.domain_name
}

output "ecr_repository_urls" {
  value = { for key, repo in aws_ecr_repository.look-card : key => repo.repository_url }
}