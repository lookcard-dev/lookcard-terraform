# RDS Proxy IAM Role
resource "aws_iam_role" "proxy_role" {
  name = "rds-proxy-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "rds.amazonaws.com"
      }
    }]
  })
  tags = {
    Environment = var.runtime_environment
    ManagedBy   = "Terraform"
  }
}

# IAM Policy for RDS Proxy to access Secrets
resource "aws_iam_role_policy" "proxy_policy" {
  name = "rds-proxy-policy"
  role = aws_iam_role.proxy_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = [var.secret_arns["DATABASE"]]
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt"
        ]
        Resource = ["*"]
        Condition = {
          StringEquals = {
            "kms:ViaService" : "secretsmanager.${var.aws_provider.region}.amazonaws.com"
          }
        }
      }
    ]
  })
}

# RDS Proxy
resource "aws_db_proxy" "this" {
  count                  = var.runtime_environment == "production" ? 1 : 0
  name                   = "database-proxy"
  debug_logging          = var.runtime_environment != "production"
  engine_family          = "POSTGRESQL"
  idle_client_timeout    = 1800
  require_tls            = true
  role_arn               = aws_iam_role.proxy_role.arn
  vpc_security_group_ids = [aws_security_group.proxy_security_group.id]
  vpc_subnet_ids         = var.subnet_ids

  auth {
    auth_scheme = "SECRETS"
    iam_auth    = "DISABLED"
    secret_arn  = var.secret_arns["DATABASE"]
  }

  tags = {
    Environment = var.runtime_environment
    ManagedBy   = "Terraform"
  }
}

# Default target group with connection pooling settings
resource "aws_db_proxy_default_target_group" "this" {
  count         = var.runtime_environment == "production" ? 1 : 0
  db_proxy_name = aws_db_proxy.this[0].name

  connection_pool_config {
    connection_borrow_timeout    = 120
    max_connections_percent      = 100
    max_idle_connections_percent = 50
    session_pinning_filters      = ["EXCLUDE_VARIABLE_SETS"]
  }
}

# Proxy target
resource "aws_db_proxy_target" "this" {
  count                 = var.runtime_environment == "production" ? 1 : 0
  db_cluster_identifier = aws_rds_cluster.cluster.id
  db_proxy_name         = aws_db_proxy.this[0].name
  target_group_name     = aws_db_proxy_default_target_group.this[0].name
}

# Read-only endpoint for the proxy
resource "aws_db_proxy_endpoint" "readonly" {
  count                  = var.runtime_environment == "production" ? 1 : 0
  db_proxy_name          = aws_db_proxy.this[0].name
  db_proxy_endpoint_name = "database-proxy-readonly"
  vpc_subnet_ids         = var.subnet_ids
  vpc_security_group_ids = [aws_security_group.proxy_security_group.id]
  target_role            = "READ_ONLY"
  tags = {
    Environment = var.runtime_environment
    ManagedBy   = "Terraform"
  }
}

# CloudWatch log group for proxy logs
resource "aws_cloudwatch_log_group" "proxy_logs" {
  name              = "/aws/rds/proxy/rds-proxy"
  retention_in_days = 30
  tags = {
    Environment = var.runtime_environment
    ManagedBy   = "Terraform"
  }
}
