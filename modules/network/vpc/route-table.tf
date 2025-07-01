resource "aws_route_table" "public_route_table" {
  count  = length(var.network.cidr.subnets.public)
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = "public-subnet-route-table-${count.index + 1}"
  }
}

resource "aws_route_table" "private_route_table" {
  count  = length(var.network.cidr.subnets.private)
  vpc_id = aws_vpc.vpc.id
  dynamic "route" {
    for_each = var.network.nat.provider == "instance" ? [1] : []
    content {
      cidr_block           = "0.0.0.0/0"
      network_interface_id = element(aws_instance.nat_instance[*].primary_network_interface_id, count.index % var.network.nat.count)
    }
  }
  dynamic "route" {
    for_each = var.network.nat.provider == "gateway" ? [1] : []
    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = element(aws_nat_gateway.nat_gateway[*].id, count.index % var.network.nat.count)
    }
  }
  tags = {
    Name = "private-subnet-route-table-${count.index + 1}"
  }
}

resource "aws_route_table" "database_route_table" {
  count  = length(var.network.cidr.subnets.database)
  vpc_id = aws_vpc.vpc.id
  lifecycle {
    ignore_changes = [route]
  }
  tags = {
    Name = "database-subnet-route-table-${count.index + 1}"
  }
}

resource "aws_route_table" "isolated_route_table" {
  count  = length(var.network.cidr.subnets.isolated)
  vpc_id = aws_vpc.vpc.id
  lifecycle {
    ignore_changes = [route]
  }
  tags = {
    Name = "isolated-subnet-route-table-${count.index + 1}"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table[count.index].id
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}

resource "aws_route_table_association" "database_subnet_association" {
  count          = length(aws_subnet.database_subnet)
  subnet_id      = aws_subnet.database_subnet[count.index].id
  route_table_id = aws_route_table.database_route_table[count.index].id
}

resource "aws_route_table_association" "isolated_subnet_association" {
  count          = length(aws_subnet.isolated_subnet)
  subnet_id      = aws_subnet.isolated_subnet[count.index].id
  route_table_id = aws_route_table.isolated_route_table[count.index].id
}
