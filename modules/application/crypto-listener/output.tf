output "transaction_listener_sg_id" {
  value = aws_security_group.transaction_listener_sg.id
}

output "crypto_listener_sg" {
  value = {
    id = aws_security_group.transaction_listener_sg.id
  }
}

output "tron_listener_ecs_svc_sg" {
  value = {
    id = aws_security_group.tron_listener_ecs_svc_sg.id
  }
}

output "transaction_listener_arm64_asg_arn" {
  value = aws_autoscaling_group.transaction_listener_arm64.arn
}

output "transaction_listener_amd64_asg_arn" {
  value = aws_autoscaling_group.transaction_listener_amd64.arn
}