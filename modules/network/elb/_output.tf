// ===== Core Application Load Balancer =====

output "core_application_load_balancer_security_group_id" {
  value = aws_security_group.core_application_load_balancer_security_group.id
}

output "core_application_load_balancer_arn" {
  value = aws_lb.core_application_load_balancer.arn
}

output "core_application_load_balancer_dns_name" {
  value = aws_lb.core_application_load_balancer.dns_name
}

output "core_application_load_balancer_http_listener_arn" {
  value = aws_lb_listener.core_application_load_balancer_http_listener.arn
}

// ===== Composite Application Load Balancer =====

output "composite_application_load_balancer_security_group_id" {
  value = aws_security_group.composite_application_load_balancer_security_group.id
}

output "composite_application_load_balancer_arn" {
  value = aws_lb.composite_application_load_balancer.arn
}

output "composite_application_load_balancer_dns_name" {
  value = aws_lb.composite_application_load_balancer.dns_name
}

output "composite_application_load_balancer_http_listener_arn" {
  value = aws_lb_listener.composite_application_load_balancer_http_listener.arn
}

// ===== Composite Network Load Balancer =====

output "composite_network_load_balancer_security_group_id" {
  value = aws_security_group.composite_network_load_balancer_security_group.id
}

output "composite_network_load_balancer_arn" {
  value = aws_lb.composite_network_load_balancer.arn
}

output "composite_network_load_balancer_dns_name" {
  value = aws_lb.composite_network_load_balancer.dns_name
}

output "composite_network_load_balancer_http_listener_arn" {
  value = aws_lb_listener.composite_network_load_balancer_http_listener.arn
}
