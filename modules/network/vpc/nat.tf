resource "aws_security_group" "nat_security_group" {
  name   = "nat-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.network.cidr.vpc]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "NAT Security Group"
  }
}

resource "aws_eip" "nat_eip" {
  count  = var.network.nat.count
  domain = "vpc"
  tags = {
    Name = "nat-eip-${count.index}"
  }
}

module "nat-instance" {
  source                        = "RaJiska/fck-nat/aws"
  count                         = var.network.nat.provider == "instance" ? var.network.nat.count : 0
  name                          = "nat-instance-${count.index + 1}"
  instance_type                 = "t4g.nano"
  vpc_id                        = aws_vpc.vpc.id
  subnet_id                     = aws_subnet.public_subnet[count.index].id
  eip_allocation_ids            = [aws_eip.nat_eip[count.index].id]
  use_default_security_group    = false
  additional_security_group_ids = [aws_security_group.nat_security_group.id]
  use_spot_instances            = var.runtime_environment == "production" ? true : false
  use_cloudwatch_agent          = false
  update_route_tables           = true
  route_tables_ids = {
    "private-route-table-${count.index + 1}" = aws_route_table.private_route_table[count.index].id
  }
  depends_on = [aws_security_group.nat_security_group, aws_eip.nat_eip]
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = var.network.nat.provider == "gateway" ? var.network.nat.count : 0
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id
  depends_on    = [aws_eip.nat_eip]
}
