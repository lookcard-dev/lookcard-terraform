# Public Route Table 
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = "public-subnet-route-table"
  }

}


# Nat Gateway Route Table
resource "aws_route_table" "private-route-table" {
  count  = var.network_config.replica_number
  vpc_id = aws_vpc.vpc.id

  dynamic "route" {
    for_each = var.network_config.gateway_enabled ? [] : [for i in range(0, var.network_config.replica_number) : i]
    content {
      cidr_block           = "0.0.0.0/0"
      network_interface_id = aws_instance.nat[route.value].primary_network_interface_id
    }
  }

  dynamic "route" {
    for_each = var.network_config.gateway_enabled ? [1] : []
    content {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.nat_gw[0].id
    }
  }

  lifecycle {
    ignore_changes = [
      route,
    ]
  }

  tags = {
    Name = "private-subnet-route-table-${element(aws_subnet.private-subnet.*.availability_zone, count.index)}"
  }
}


resource "aws_route_table_association" "private_subnet_association" {
  count          = length(aws_subnet.private-subnet) # Ensure count matches the number of private subnets
  subnet_id      = element(aws_subnet.private-subnet.*.id, count.index)
  route_table_id = element(aws_route_table.private-route-table.*.id, count.index)
}

# Assuming you have a list of private subnets defined elsewhere, named aws_subnet.look-card-Private-Sub
resource "aws_route_table" "database-route-table" {

  vpc_id = aws_vpc.vpc.id


  lifecycle {
    ignore_changes = [
      route,
    ]
  }
  tags = {
    Name = "database-route-table"
  }

}

resource "aws_route_table" "isolated-route-table" {
  vpc_id = aws_vpc.vpc.id
  lifecycle {
    ignore_changes = [
      route,
    ]
  }
  tags = {
    Name = "isolated-route-table"
  }

}

resource "aws_route_table_association" "isolated_subnet_association" {
  count          = length(aws_subnet.isolated-subnet)
  subnet_id      = aws_subnet.isolated-subnet[count.index].id
  route_table_id = aws_route_table.isolated-route-table.id
}

resource "aws_route_table_association" "database_subnet_association" {
  count          = length(aws_subnet.database-subnet)
  subnet_id      = aws_subnet.database-subnet[count.index].id
  route_table_id = aws_route_table.database-route-table.id
}


resource "aws_route_table_association" "public_subnet_association" {
  count          = length(aws_subnet.public-subnet)
  subnet_id      = aws_subnet.public-subnet[count.index].id
  route_table_id = aws_route_table.public-route-table.id
}


