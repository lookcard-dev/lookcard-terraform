output "account_api_sg_id" {
  value = aws_security_group.account_api_sg.id
}

output "account_api_ecs_svc_sg" {
  value = {
    id = aws_security_group.account_api_ecs_svc_sg.id
  }
}