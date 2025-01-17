
resource "aws_subnet" "public_subnet" {
  depends_on              = [aws_vpc.vpc]
  count                   = length(var.network.cidr.subnets.public)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.network.cidr.subnets.public[count.index]
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  depends_on              = [aws_vpc.vpc]
  count                   = length(var.network.cidr.subnets.private)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.network.cidr.subnets.private[count.index]
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "database_subnet" {
  depends_on              = [aws_vpc.vpc]
  count                   = length(var.network.cidr.subnets.database)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.network.cidr.subnets.database[count.index]
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name = "database-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "isolated_subnet" {
  depends_on              = [aws_vpc.vpc]
  count                   = length(var.network.cidr.subnets.isolated)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.network.cidr.subnets.isolated[count.index]
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name = "isolated-subnet-${count.index + 1}"
  }
}
