output "user_api_sg" {
  value = aws_security_group.user_api_security_grp.id
}

output "user_api_ecs_svc_sg" {
  value = aws_security_group.user_api_ecs_svc_sg.id
}