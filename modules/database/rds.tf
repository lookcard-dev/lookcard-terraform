provider "aws" {
  region = "ap-southeast-1"
}

# Store the password in AWS Secrets Manager
resource "aws_secretsmanager_secret" "lookcard_db_secret" {
  name = "lookcard_db_master_password"
}

resource "aws_secretsmanager_secret_version" "lookcard_db_secret_version" {
  secret_id     = aws_secretsmanager_secret.lookcard_db_secret.id
  secret_string = var.lookcard_rds_password
}

# Define the DB subnet group
resource "aws_db_subnet_group" "lookcard_rds_subnet" {
  name       = "lookcard_rds_subnet"
  subnet_ids = [var.network.private_subnet[0], var.network.private_subnet[1], var.network.private_subnet[2]] 
}

# Define the RDS Aurora Serverless V2 cluster
resource "aws_rds_cluster" "lookcard" {
  cluster_identifier      = "lookcard-testing-db"
  database_name           = "lookcardtest"
  engine                  = "aurora-postgresql"
  engine_mode             = "provisioned"
  serverlessv2_scaling_configuration {
    min_capacity           = 2
    max_capacity           = 8
  }
  master_username         = "lookcard"
  master_password         = aws_secretsmanager_secret_version.lookcard_db_secret_version.secret_string
  db_subnet_group_name    = aws_db_subnet_group.lookcard_rds_subnet.name
  vpc_security_group_ids  = [aws_security_group.lookcard_db_rds_sg.id]
  skip_final_snapshot     = true
  deletion_protection     = false
  storage_encrypted       = true
}

# Define the second RDS standard cluster
resource "aws_rds_cluster" "lookcard_2" {
  cluster_identifier      = "lookcard-standard-db"
  database_name           = "lookcardstandard"
  engine                  = "aurora-postgresql"
  master_username         = "lookcard"
  master_password         = aws_secretsmanager_secret_version.lookcard_db_secret_version.secret_string
  db_subnet_group_name    = aws_db_subnet_group.lookcard_rds_subnet.name
  vpc_security_group_ids  = [aws_security_group.lookcard_db_rds_sg.id]
  skip_final_snapshot     = true
  deletion_protection     = false
  storage_encrypted       = true
}

# Define the instance for the standard RDS cluster
resource "aws_rds_cluster_instance" "lookcard_2_instance" {
  cluster_identifier           = aws_rds_cluster.lookcard_2.id
  instance_class               = "db.t3.medium"
  engine                       = "aurora-postgresql"
  db_subnet_group_name         = aws_db_subnet_group.lookcard_rds_subnet.name
  publicly_accessible          = false
  performance_insights_enabled = true
  monitoring_interval          = 60
  monitoring_role_arn          = aws_iam_role.rds_monitoring_role.arn
}

# Define the RDS Proxy for the serverless cluster
resource "aws_db_proxy" "lookcard_rds_proxy" {
  name                   = "lookcard-rds-proxy"
  engine_family          = "POSTGRESQL"
  role_arn               = aws_iam_role.rds_proxy_role.arn
  vpc_subnet_ids         = var.network.private_subnet
  vpc_security_group_ids = [aws_security_group.lookcard_db_rds_sg.id]
  auth {
    auth_scheme = "SECRETS"
    secret_arn  = aws_secretsmanager_secret.lookcard_db_secret.arn
  }
  require_tls            = true
}

# Associate the RDS Serverless Cluster with the RDS Proxy
resource "aws_db_proxy_target" "lookcard_proxy_target" {
  db_proxy_name         = aws_db_proxy.lookcard_rds_proxy.name
  target_group_name     = "default"
  db_cluster_identifier = aws_rds_cluster.lookcard.id
}

# Define the RDS Proxy for the standard cluster
resource "aws_db_proxy" "lookcard_rds_proxy_2" {
  name                   = "lookcard-rds-proxy-2"
  engine_family          = "POSTGRESQL"
  role_arn               = aws_iam_role.rds_proxy_role.arn
  vpc_subnet_ids         = var.network.private_subnet
  vpc_security_group_ids = [aws_security_group.lookcard_db_rds_sg.id]
  auth {
    auth_scheme = "SECRETS"
    secret_arn  = aws_secretsmanager_secret.lookcard_db_secret.arn
  }
  require_tls            = true
}

# Associate the RDS Standard Cluster with the RDS Proxy
resource "aws_db_proxy_target" "lookcard_proxy_target_2" {
  db_proxy_name         = aws_db_proxy.lookcard_rds_proxy_2.name
  target_group_name     = "default"
  db_cluster_identifier = aws_rds_cluster.lookcard_2.id
}

# IAM role for RDS Proxy
resource "aws_iam_role" "rds_proxy_role" {
  name = "lookcard-rds-proxy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "rds.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds_proxy_role_policy" {
  role       = aws_iam_role.rds_proxy_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

# Define the security group
resource "aws_security_group" "lookcard_db_rds_sg" {
  name        = "Database-Security-Group"
  description = "Security group for RDS services"
  vpc_id      = var.network.vpc

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "look-card-DB-sg"
  }
}

# IAM role and policy attachment for monitoring
resource "aws_iam_role" "rds_monitoring_role" {
  name = "lookcard-rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
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
