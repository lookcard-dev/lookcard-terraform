output "referral_api_sg" {
  value = aws_security_group.referral_api_security_group.id
}
output "referral_api_ecs_svc_sg" {
  value = aws_security_group.referral_api_ecs_svc_sg.id
}