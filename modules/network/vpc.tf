resource "aws_vpc" "look-card" {
  cidr_block                       = var.network.vpc_cidr
  enable_dns_hostnames             = "true"
  enable_dns_support               = "true"
  assign_generated_ipv6_cidr_block = "true"
  tags = {
    Name = "look-card-vpc"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.look-card.id
  tags = {
    Name = "Internet-Gateway-Public"
  }

}


# resource "aws_eip" "nat-ip" {
#   count  = var.network_config.gateway_enabled ? var.network_config.replica_number : 0
#   domain = "vpc"
#   tags = {
#     Name = "NAT-Gateway-EIP-${count.index}"
#   }
# }


# resource "aws_nat_gateway" "nat-gateway" {
#   count         = var.network_config.gateway_enabled ? var.network_config.replica_number : 0
#   allocation_id = aws_eip.nat-ip[count.index].id
#   subnet_id     = aws_subnet.look-card-public-subnet[count.index].id
#   tags = {
#     Name = "NAT-Gateway-${count.index}"
#   }
# }
