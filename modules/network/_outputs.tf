output "vpc_id" {
  value = module.vpc.vpc_id
}

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

output "cloudmap_namespace_id" {
  value = module.cloudmap.namespace_id
}

output "application_load_balancer_arn" {
  value = module.elb.application_load_balancer_arn
}

output "network_load_balancer_arn" {
  value = module.elb.network_load_balancer_arn
}

output "application_load_balancer_dns_name" {
  value = module.elb.application_load_balancer_dns_name
}

output "network_load_balancer_dns_name" {
  value = module.elb.network_load_balancer_dns_name
}

output "application_load_balancer_http_listener_arn" {
  value = module.elb.application_load_balancer_http_listener_arn
}

output "api_gateway_vpc_link_arn" {
  value = module.api_gateway.vpc_link_arn
}

output "api_gateway_vpc_link_id" {
  value = module.api_gateway.vpc_link_id
}

output "bastion_host_security_group_id" {
  value = module.bastion_host.bastion_host_security_group_id
}

output "application_load_balancer_security_group_id" {
  value = module.elb.application_load_balancer_security_group_id
}

output "network_load_balancer_security_group_id" {
  value = module.elb.network_load_balancer_security_group_id
}
