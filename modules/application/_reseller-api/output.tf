output "reseller_api_sg" {
  value = aws_security_group.reseller_api_sg.id
}

output "reseller_api_ecs_svc_sg" {
  value = {
    id = aws_security_group.reseller_api_ecs_svc_sg.id
  }
}