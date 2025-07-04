output "security_group_id" {
  value = aws_security_group.security_group.id
}

output "target_group_arn" {
  value = aws_lb_target_group.service_target_group.arn
}

output "target_group_name" {
  value = aws_lb_target_group.service_target_group.name
}

output "service_discovery_service_arn" {
  value = aws_service_discovery_service.discovery_service.arn
}

output "service_discovery_service_name" {
  value = aws_service_discovery_service.discovery_service.name
}
