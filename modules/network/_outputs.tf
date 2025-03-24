output "vpc_id" {
  value = module.vpc.vpc_id
}

// ===== Subnets =====
output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "isolated_subnet_ids" {
  value = module.vpc.isolated_subnet_ids
}

output "database_subnet_ids" {
  value = module.vpc.database_subnet_ids
}

// ===== CloudMap =====
output "cloudmap_namespace_id" {
  value = module.cloudmap.namespace_id
}

// ===== Core Application Load Balancer =====

output "core_application_load_balancer_security_group_id" {
  value = module.elb.core_application_load_balancer_security_group_id
}

output "core_application_load_balancer_arn" {
  value = module.elb.core_application_load_balancer_arn
}

output "core_application_load_balancer_dns_name" {
  value = module.elb.core_application_load_balancer_dns_name
}

output "core_application_load_balancer_http_listener_arn" {
  value = module.elb.core_application_load_balancer_http_listener_arn
}

// ===== Composite Application Load Balancer =====

output "composite_application_load_balancer_security_group_id" {
  value = module.elb.composite_application_load_balancer_security_group_id
}

output "composite_application_load_balancer_arn" {
  value = module.elb.composite_application_load_balancer_arn
}

output "composite_application_load_balancer_dns_name" {
  value = module.elb.composite_application_load_balancer_dns_name
}

output "composite_application_load_balancer_http_listener_arn" {
  value = module.elb.composite_application_load_balancer_http_listener_arn
}

// ===== Composite Network Load Balancer =====

output "composite_network_load_balancer_security_group_id" {
  value = module.elb.composite_network_load_balancer_security_group_id
}

output "composite_network_load_balancer_arn" {
  value = module.elb.composite_network_load_balancer_arn
}

output "composite_network_load_balancer_dns_name" {
  value = module.elb.composite_network_load_balancer_dns_name
}

output "composite_network_load_balancer_http_listener_arn" {
  value = module.elb.composite_network_load_balancer_http_listener_arn
}

# // ===== API Gateway =====

# output "api_gateway_vpc_link_arn" {
#   value = module.api_gateway.vpc_link_arn
# }

# output "api_gateway_vpc_link_id" {
#   value = module.api_gateway.vpc_link_id
# }
