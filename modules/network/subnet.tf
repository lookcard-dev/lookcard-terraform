
# look-card-Public-Subnet

resource "aws_subnet" "public_subnet" {
  depends_on              = [aws_vpc.vpc]
  count                   = length(var.network.public_subnet_cidr_list)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.network.public_subnet_cidr_list[count.index]
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${count.index}"
  }
}


# look-card-Private-Sub

resource "aws_subnet" "private_subnet" {
  depends_on              = [aws_vpc.vpc]
  count                   = length(var.network.private_subnet_cidr_list)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.network.private_subnet_cidr_list[count.index]
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name = "private-subnet-${count.index}"
  }
}

# look-card-Database-Sub

resource "aws_subnet" "database_subnet" {
  depends_on              = [aws_vpc.vpc]
  count                   = length(var.network.database_subnet_cidr_list)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.network.database_subnet_cidr_list[count.index]
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name = "database-subnet-${count.index}"
  }
}

# look-card-isolated-Sub

resource "aws_subnet" "isolated_subnet" {
  depends_on              = [aws_vpc.vpc]
  count                   = length(var.network.isolated_subnet_cidr_list)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.network.isolated_subnet_cidr_list[count.index]
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name = "isolated-subnet-${count.index}"
  }
}
