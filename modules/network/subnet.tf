
# look-card-Public-Subnet

resource "aws_subnet" "look-card-public-subnet" {
  depends_on              = [aws_vpc.look-card]
  count                   = length(var.network.public_subnet_cidr_list)
  vpc_id                  = aws_vpc.look-card.id
  cidr_block              = var.network.public_subnet_cidr_list[count.index]
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "look-card-public-subnet-${count.index}"
  }

}


# look-card-Private-Sub

resource "aws_subnet" "look-card-private-subnet" {
  depends_on              = [aws_vpc.look-card]
  count                   = length(var.network.private_subnet_cidr_list)
  vpc_id                  = aws_vpc.look-card.id
  cidr_block              = var.network.private_subnet_cidr_list[count.index]
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name = "look-card-private-subnet-${count.index}"
  }
}

# look-card-Database-Sub

resource "aws_subnet" "look-card-database-subnet" {
  depends_on              = [aws_vpc.look-card]
  count                   = length(var.network.database_subnet_cidr_list)
  vpc_id                  = aws_vpc.look-card.id
  cidr_block              = var.network.database_subnet_cidr_list[count.index]
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name = "look-card-database-subnet-${count.index}"
  }
}

# look-card-isolated-Sub

resource "aws_subnet" "look-card-isolated-subnet" {
  depends_on              = [aws_vpc.look-card]
  count                   = length(var.network.isolated_subnet_cidr_list)
  vpc_id                  = aws_vpc.look-card.id
  cidr_block              = var.network.isolated_subnet_cidr_list[count.index]
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name = "look-card-isolated-Sub-${count.index}"
  }
}
