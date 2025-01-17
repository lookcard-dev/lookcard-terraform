# # Output for Public Subnet IDs

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

# output "rt_private_id" {
#   value = module.vpc.rt_private_id
# }

# output "public_subnet_cidr_lists" {
#   value = module.vpc.public_subnet_cidr_lists
# }

# output "Database_Sub_ids" {
#   value = aws_subnet.look-card-Database-Sub[*].id

# }

# # Output for Private Subnet IDs

# # Output for Internet Gateway ID
# output "internet_gateway_id" {
#   value = aws_internet_gateway.IGW.id
# }

# # Output for Elastic IP Allocation ID
# output "nat_eip_allocation_id" {
#   value = aws_eip.Nat-EIP[*].id
# }

# # Output for NAT Gateway ID
# output "nat_gateway_id" {
#   value = aws_nat_gateway.NGW_Private_Sub[*].id
# }

# output "isolated" {
#   value = aws_subnet.look-card-isolated-Sub[*].id

# }



