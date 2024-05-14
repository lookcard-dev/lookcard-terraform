# Public Route Table 
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.look-card.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = "Public-Subnet-Route-Table"
  }

}


# Nat Gateway Route Table
# resource "aws_route_table" "private-route-table" {

#   count  = var.network_config.replica_number
#   vpc_id = aws_vpc.look-card.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.nat-gateway[count.index].id
#   }

#   lifecycle {
#     ignore_changes = [
#       route,
#     ]
#   }

#   tags = {
#     Name = "Private-Subnet-Route-Table-${aws_subnet.look-card-private-subnet[count.index].availability_zone}"
#   }
# }

# resource "aws_route_table_association" "private_subnet_association" {
#   count          = length(aws_subnet.look-card-private-subnet) # Ensure count matches the number of subnets
#   subnet_id      = aws_subnet.look-card-private-subnet[count.index].id
#   route_table_id = aws_route_table.private-route-table[count.index].id
# }


# Assuming you have a list of private subnets defined elsewhere, named aws_subnet.look-card-Private-Sub

resource "aws_route_table" "database-route-table" {

  vpc_id = aws_vpc.look-card.id


  lifecycle {
    ignore_changes = [
      route,
    ]
  }
  tags = {
    Name = "Database-Route-Table"
  }

}

resource "aws_route_table" "isolated-route-table" {
  vpc_id = aws_vpc.look-card.id
  lifecycle {
    ignore_changes = [
      route,
    ]
  }
  tags = {
    Name = "Isolated-Route-Table"
  }

}

resource "aws_route_table_association" "isolated_subnet_association" {
  count          = length(aws_subnet.look-card-isolated-subnet)
  subnet_id      = aws_subnet.look-card-isolated-subnet[count.index].id
  route_table_id = aws_route_table.isolated-route-table.id
}

resource "aws_route_table_association" "database_subnet_association" {
  count          = length(aws_subnet.look-card-database-subnet)
  subnet_id      = aws_subnet.look-card-database-subnet[count.index].id
  route_table_id = aws_route_table.database-route-table.id
}


resource "aws_route_table_association" "public_subnet_association" {
  count          = length(aws_subnet.look-card-public-subnet)
  subnet_id      = aws_subnet.look-card-public-subnet[count.index].id
  route_table_id = aws_route_table.public-route-table.id
}


