output "application_load_balancer_arn" {
  value = aws_lb.application_load_balancer.arn
}

output "application_load_balancer_dns_name" {
  value = aws_lb.application_load_balancer.dns_name
}

output "network_load_balancer_arn" {
  value = aws_lb.network_load_balancer.arn
}

output "network_load_balancer_dns_name" {
  value = aws_lb.network_load_balancer.dns_name
}

output "application_load_balancer_http_listener_arn" {
  value = aws_lb_listener.application_load_balancer_http_listener.arn
}

output "application_load_balancer_security_group_id" {
  value = aws_security_group.application_load_balancer_security_group.id
}

output "network_load_balancer_security_group_id" {
  value = aws_security_group.network_load_balancer_security_group.id
}

output "application_load_balancer_arn_suffix" {
  value = aws_lb.application_load_balancer.arn_suffix
}

output "network_load_balancer_arn_suffix" {
  value = aws_lb.network_load_balancer.arn_suffix
}