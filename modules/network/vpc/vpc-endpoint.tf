resource "aws_vpc_endpoint" "s3_gateway" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.aws_provider.region}.s3"
  route_table_ids = [aws_route_table.private_route_table[*].id, aws_route_table.isolated_route_table[*].id]
}

resource "aws_security_group" "ecr_api" {
  depends_on  = [aws_vpc.vpc]
  name        = "ecr-api-endpoint-sg"
  vpc_id      = aws_vpc.vpc.id
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.network.cidr.vpc]
  }
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.aws_provider.region}.ecr.api"
  vpc_endpoint_type = "Interface"
  subnet_ids        = concat(aws_subnet.private_subnet[*].id, aws_subnet.isolated_subnet[*].id)
  security_group_ids = [aws_security_group.ecr_api.id]
  private_dns_enabled = true
}

resource "aws_security_group" "ecr_dkr" {
  depends_on  = [aws_vpc.vpc]
  name        = "ecr-dkr-endpoint-sg"
  vpc_id      = aws_vpc.vpc.id
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.network.cidr.vpc]
  }
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.aws_provider.region}.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids        = concat(aws_subnet.private_subnet[*].id, aws_subnet.isolated_subnet[*].id)
  security_group_ids = [aws_security_group.ecr_dkr.id]
  private_dns_enabled = true
}

resource "aws_security_group" "sqs" {
  depends_on  = [aws_vpc.vpc]
  name        = "sqs-endpoint-sg"
  vpc_id      = aws_vpc.vpc.id
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.network.cidr.vpc]
  }
}

resource "aws_vpc_endpoint" "sqs" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.aws_provider.region}.sqs"
  vpc_endpoint_type = "Interface"
  subnet_ids        = concat(aws_subnet.private_subnet[*].id, aws_subnet.isolated_subnet[*].id)
  security_group_ids = [aws_security_group.sqs.id]
  private_dns_enabled = true
}

resource "aws_security_group" "secrets_manager" {
  depends_on  = [aws_vpc.vpc]
  name        = "secretsmanager-endpoint-sg"
  vpc_id      = aws_vpc.vpc.id
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.network.cidr.vpc]
  }
}

resource "aws_vpc_endpoint" "secrets_manager" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.aws_provider.region}.secretsmanager"
  vpc_endpoint_type = "Interface"
  subnet_ids        = concat(aws_subnet.private_subnet[*].id, aws_subnet.isolated_subnet[*].id)
  security_group_ids = [aws_security_group.secrets_manager.id]
  private_dns_enabled = true
}

resource "aws_security_group" "firehose" {
  depends_on  = [aws_vpc.vpc]
  name        = "firehose-endpoint-sg"
  vpc_id      = aws_vpc.vpc.id
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.network.cidr.vpc]
  }
}

resource "aws_vpc_endpoint" "firehose" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.aws_provider.region}.kinesis-firehose"
  vpc_endpoint_type = "Interface"
  subnet_ids        = concat(aws_subnet.private_subnet[*].id, aws_subnet.isolated_subnet[*].id)
  security_group_ids = [aws_security_group.firehose.id]
  private_dns_enabled = true
}