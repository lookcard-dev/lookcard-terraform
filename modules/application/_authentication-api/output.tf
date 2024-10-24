# output "default_listener" {
#   value = aws_lb_listener.look-card.arn

# }

# output "auth_tg" {
#   value = aws_lb_target_group.Authentication_TGP.arn_suffix
# }

output "authentication_tgp_arn" {
  value = aws_lb_target_group.authentication_tgp.arn
}

output "_auth_api_sg" {
  value = aws_security_group.authentication.id
}