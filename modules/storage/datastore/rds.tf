# Define the DB subnet group
resource "aws_db_subnet_group" "subnet_group" {
  name       = "datastore-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "random_password" "master_password" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

data "aws_secretsmanager_secret" "database" {
  name = "DATABASE"
}

resource "aws_secretsmanager_secret_version" "database_secret_version" {
  secret_id = data.aws_secretsmanager_secret.database.id
  secret_string = jsonencode({
    username             = var.runtime_environment
    password             = random_password.master_password.result
    engine               = "postgres"
    host                 = aws_rds_cluster.cluster.endpoint
    port                 = 5432
    dbname               = var.runtime_environment
    dbInstanceIdentifier = aws_rds_cluster.cluster.cluster_identifier
  })
}

# rds cluster
resource "aws_rds_cluster" "cluster" {
  cluster_identifier     = "datastore"
  engine                 = "aurora-postgresql"
  engine_mode            = "provisioned"
  engine_version         = "16.1"
  database_name          = var.runtime_environment
  master_username        = var.runtime_environment
  master_password        = random_password.master_password.result
  db_subnet_group_name   = aws_db_subnet_group.subnet_group.name
  vpc_security_group_ids = [aws_security_group.cluster_security_group.id]
  
  # Backup configuration
  backup_retention_period = var.runtime_environment == "production" ? 30 : 7
  preferred_backup_window = "03:00-04:00"
  copy_tags_to_snapshot  = true
  
  # Maintenance and updates
  preferred_maintenance_window = "Mon:04:00-Mon:05:00"
  
  # Security
  storage_encrypted      = true
  iam_database_authentication_enabled = true
  
  # Production settings
  deletion_protection    = var.runtime_environment == "production"
  skip_final_snapshot    = var.runtime_environment != "production"
  final_snapshot_identifier = var.runtime_environment == "production" ? "${var.runtime_environment}-final-snapshot" : null

  # Performance and scaling
  serverlessv2_scaling_configuration {
    max_capacity = var.runtime_environment == "production" ? 4.0 : 2.0
    min_capacity = var.runtime_environment == "production" ? 1.0 : 0.5
  }

  # Enable Performance Insights
  performance_insights_enabled    = true
  performance_insights_retention_period = var.runtime_environment == "production" ? 180 : 7
}

resource "aws_rds_cluster_instance" "writer" {
  identifier         = "writer"
  cluster_identifier = aws_rds_cluster.cluster.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.cluster.engine
  engine_version     = aws_rds_cluster.cluster.engine_version
  publicly_accessible = false
  performance_insights_enabled    = true
  monitoring_interval            = 60
  monitoring_role_arn           = aws_iam_role.rds_monitoring_role.arn
}

resource "aws_rds_cluster_instance" "reader" {
  count              = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 2 : 1
  identifier         = "reader-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.cluster.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.cluster.engine
  engine_version     = aws_rds_cluster.cluster.engine_version
  publicly_accessible = false
  performance_insights_enabled    = true
  monitoring_interval            = 60
  monitoring_role_arn           = aws_iam_role.rds_monitoring_role.arn
}

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
        Resource = [data.aws_secretsmanager_secret.database.arn]
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt"
        ]
        Resource = ["*"]
        Condition = {
          StringEquals = {
            "kms:ViaService": "secretsmanager.${var.aws_provider.region}.amazonaws.com"
          }
        }
      }
    ]
  })
}

# RDS Proxy
resource "aws_db_proxy" "this" {
  name                   = "database-proxy"
  debug_logging          = var.runtime_environment != "production"
  engine_family          = "POSTGRESQL"
  idle_client_timeout    = 1800
  require_tls           = true
  role_arn              = aws_iam_role.proxy_role.arn
  vpc_security_group_ids = [aws_security_group.proxy_security_group.id]
  vpc_subnet_ids         = var.subnet_ids

  auth {
    auth_scheme = "SECRETS"
    iam_auth    = "DISABLED"
    secret_arn  = data.aws_secretsmanager_secret.database.arn
  }

  tags = {
    Environment = var.runtime_environment
    ManagedBy   = "Terraform"
  }
}

# Default target group with connection pooling settings
resource "aws_db_proxy_default_target_group" "this" {
  db_proxy_name = aws_db_proxy.this.name

  connection_pool_config {
    connection_borrow_timeout    = 120
    max_connections_percent      = 100
    max_idle_connections_percent = 50
    session_pinning_filters      = ["EXCLUDE_VARIABLE_SETS"]
  }
}

# Proxy target
resource "aws_db_proxy_target" "this" {
  db_cluster_identifier = aws_rds_cluster.cluster.id
  db_proxy_name        = aws_db_proxy.this.name
  target_group_name    = aws_db_proxy_default_target_group.this.name
}

# Read-only endpoint for the proxy
resource "aws_db_proxy_endpoint" "readonly" {
  db_proxy_name          = aws_db_proxy.this.name
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
  retention_in_days = var.runtime_environment == "production" ? 30 : 7

  tags = {
    Environment = var.runtime_environment
    ManagedBy   = "Terraform"
  }
}


# IAM role and policy attachment for monitoring
resource "aws_iam_role" "rds_monitoring_role" {
  name = "rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds_monitoring_role_policy" {
  role       = aws_iam_role.rds_monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}