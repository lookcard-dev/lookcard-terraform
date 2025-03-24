output "security_group_id" {
  value = aws_security_group.security_group.id
}

output "alb_target_group_arn" {
  value = aws_lb_target_group.alb_target_group.arn
}