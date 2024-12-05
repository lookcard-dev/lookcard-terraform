resource "aws_security_group" "vpc_endpoint" {
  name        = "VPC-endpoint-SG"
  description = "Security group for VPC Endpoint"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "VPC-Endpoint-Security-Group"
  }
}

resource "aws_security_group" "ecr_dkr_endpoint_sg" {
  depends_on  = [aws_vpc.vpc]
  name        = "ecr-dkr-endpoint-sg"
  description = "Use for VPC Endpoint - ECR DKR"
  vpc_id      = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = [8080, 80]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.network.vpc_cidr]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecr-dkr-endpoint-sg"
  }
}

resource "aws_security_group" "ecr_api_endpoint_sg" {
  depends_on  = [aws_vpc.vpc]
  name        = "ecr-api-endpoint-sg"
  description = "Use for VPC Endpoint - ECR API"
  vpc_id      = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = [8080, 80]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.network.vpc_cidr]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecr-api-endpoint-sg"
  }
}

resource "aws_security_group" "sqs_endpoint_sg" {
  depends_on  = [aws_vpc.vpc]
  name        = "sqs-endpoint-sg"
  description = "Use for VPC Endpoint - SQS"
  vpc_id      = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = [8080, 80]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.network.vpc_cidr]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sqs-endpoint-sg"
  }
}

resource "aws_security_group" "secrets_manager_endpoint_sg" {
  depends_on  = [aws_vpc.vpc]
  name        = "secrets-manager-endpoint-sg"
  description = "Use for VPC Endpoint - Secrets Manager"
  vpc_id      = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = [8080, 80]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.network.vpc_cidr]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "secrets-manager-endpoint-sg"
  }
}

resource "aws_security_group" "firehose_endpoint_sg" {
  depends_on  = [aws_vpc.vpc]
  name        = "firehose-endpoint-sg"
  description = "Use for VPC Endpoint - Firehose"
  vpc_id      = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = [8080, 80]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.network.vpc_cidr]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "firehose-endpoint-sg"
  }
}