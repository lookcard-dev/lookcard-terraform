output "data_api_ecs_svc_sg" {
  value = {
    id = aws_security_group.data_api_ecs_svc_sg.id
  }
}
