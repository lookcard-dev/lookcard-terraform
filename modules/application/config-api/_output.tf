output "config_api_ecs_svc_sg" {
  value = {
    id = aws_security_group.config_api_ecs_svc_sg.id
  }
}