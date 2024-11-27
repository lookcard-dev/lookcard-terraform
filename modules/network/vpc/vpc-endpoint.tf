resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.ap-southeast-1.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids        = tolist(aws_subnet.private_subnet[*].id)

  security_group_ids = [aws_security_group.vpc_endpoint.id]

  private_dns_enabled = true

  tags = {
    Name = "ecr-api-endpoint"
  }
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.ap-southeast-1.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids        = tolist(aws_subnet.private_subnet[*].id)

  security_group_ids = [aws_security_group.vpc_endpoint.id]

  private_dns_enabled = true

  tags = {
    Name = "ecr-dkr-endpoint"
  }
}

resource "aws_vpc_endpoint" "s3_gateway" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.ap-southeast-1.s3"
  route_table_ids = [aws_route_table.private_route_table[0].id]

  tags = {
    Name = "s3-endpoint"
  }
}