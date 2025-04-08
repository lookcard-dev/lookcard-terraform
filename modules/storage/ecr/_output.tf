output "repository_urls" {
  value = {
    for key, value in aws_ecr_repository.repository : key => value.repository_url
  }
}


