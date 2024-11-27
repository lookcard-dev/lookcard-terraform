# resource "aws_vpc" "vpc" {
#   cidr_block                       = var.network.vpc_cidr
#   enable_dns_hostnames             = "true"
#   enable_dns_support               = "true"
#   assign_generated_ipv6_cidr_block = "true"
#   tags = {
#     Name = "vpc"
#   }
# }

# resource "aws_internet_gateway" "internet_gateway" {
#   vpc_id = aws_vpc.vpc.id
#   tags = {
#     Name = "internet-gateway-public"
#   }

# }


# resource "aws_security_group" "nat_sg" {
#   name_prefix = "nat-sg"
#   vpc_id      = aws_vpc.vpc.id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = -1
#     to_port     = -1
#     protocol    = "icmp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "NAT Security Group"
#   }
# }

# # 创建 NAT 实例
# resource "aws_instance" "nat" {
#   count                  = var.network_config.gateway_enabled ? 0 : var.network_config.replica_number
#   ami                    = data.aws_ami.nat_ami.id
#   instance_type          = "t3.small"
#   subnet_id              = aws_subnet.public_subnet[2].id
#   vpc_security_group_ids = [aws_security_group.nat_sg.id] # 使用安全组的ID
#   source_dest_check      = false
#   tags = {
#     Name = "NAT Instance"
#   }
#   depends_on = [aws_security_group.nat_sg]
# }

# resource "aws_eip" "nat_eip" {
#   count = var.network_config.gateway_enabled ? 1 : var.network_config.replica_number
#   domain = "vpc"
#   tags = {
#     Name = "NAT-EIP-${count.index}"
#   }
# }

# resource "aws_eip_association" "nat_eip_assoc" {
#   count         = var.network_config.gateway_enabled ? 0 : var.network_config.replica_number
#   instance_id   = element(aws_instance.nat.*.id, count.index)
#   allocation_id = element(aws_eip.nat_eip.*.id, count.index)

#   depends_on = [aws_instance.nat]
# }

# resource "aws_nat_gateway" "nat_gw" {
#   count       = var.network_config.gateway_enabled ? 1 : 0
#   allocation_id = element(aws_eip.nat_eip.*.id, 0)
#   subnet_id   = element(aws_subnet.public_subnet.*.id, 0)
#   depends_on = [aws_eip.nat_eip]
# }
