output "verification_api_sg" {
  value = aws_security_group.verification_api_security_grp.id
}

output "verification_api_ecs_svc_sg" {
  value = aws_security_group.verification_api_ecs_svc_sg.id
}