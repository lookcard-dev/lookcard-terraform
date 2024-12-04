output "crypto_api_sg_id" {
  value = aws_security_group.crypto-api-sg.id
}

output "crypto_api_ecs_svc_sg" {
  value = {
    id = aws_security_group.crypto_api_ecs_svc_sg.id
  }
}