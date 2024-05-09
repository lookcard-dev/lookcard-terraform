# # Output for Public Subnet IDs

# output "vpc" {
#   value = aws_vpc.look-card.id

# }
# output "public_subnet_ids" {
#   value = aws_subnet.look-card-Public-Sub[*].id
# }

# output "Database_Sub_ids" {
#   value = aws_subnet.look-card-Database-Sub[*].id

# }

# # Output for Private Subnet IDs
# output "private_subnet_ids" {
#   value = aws_subnet.look-card-Private-Sub[*].id
# }

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



