resource "aws_security_group" "security_group" {
  name        = "database-sg"
  vpc_id      = var.network.vpc

  // TODO:
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
}

# Define the DB subnet group
resource "aws_db_subnet_group" "subnet_group" {
  name       = "database_subnet_group"
  subnet_ids = var.subnet_ids
}

// rds cluster
resource "aws_rds_cluster" "cluster" {
  cluster_identifier     = "datastore"
  engine                 = "aurora-postgresql"
  engine_mode            = "provisioned"
  database_name          = var.runtime_environment
  master_username        = var.runtime_environment
  master_password        = local.password
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet.name
  vpc_security_group_ids = [aws_security_group.db_rds_sg.id]
  storage_encrypted      = true
  skip_final_snapshot    = true
  deletion_protection    = false
  serverlessv2_scaling_configuration {
    max_capacity = 2.0
    min_capacity = 0.5
  }
}

resource "aws_rds_cluster_instance" "writer" {
  cluster_identifier = aws_rds_cluster.cluster.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.cluster.engine
  engine_version     = aws_rds_cluster.cluster.engine_version
  publicly_accessible = false
  count = 2
}

// rds read_instance
# Define the read instance
# resource "aws_rds_cluster_instance" "read_instance" {
#   cluster_identifier = aws_rds_cluster.lookcard_develop.id
#   instance_class     = "db.serverless"
#   engine             = aws_rds_cluster.lookcard_develop.engine
#   engine_version     = aws_rds_cluster.lookcard_develop.engine_version
#   publicly_accessible = false
# }
//////////////////////////////////////////////////////////////////////////////////

# Define the RDS Proxy for the standard cluster
# resource "aws_db_proxy" "rds_proxy" {
#   name                   = "rds-proxy"
#   engine_family          = "POSTGRESQL"
#   role_arn               = aws_iam_role.rds_proxy_role.arn
#   vpc_subnet_ids         = var.network.private_subnet
#   vpc_security_group_ids = [aws_security_group.db_rds_sg.id]
#   auth {
#     auth_scheme = "SECRETS"
#     secret_arn  = var.secret_manager.database_secret_arn
#   }
#   require_tls = true
# }

# Associate the RDS Standard Cluster with the RDS Proxy
# resource "aws_db_proxy_target" "proxy_target" {
#   db_proxy_name         = aws_db_proxy.rds_proxy.name
#   target_group_name     = "default"
#   db_cluster_identifier = aws_rds_cluster.lookcard_develop.id
# }

# Define an additional RDS Proxy endpoint
# resource "aws_db_proxy_endpoint" "rds_proxy_read_endpoint" {
#   db_proxy_name          = aws_db_proxy.rds_proxy.name
#   vpc_subnet_ids         = var.network.private_subnet
#   vpc_security_group_ids = [aws_security_group.db_rds_sg.id]
#   target_role            = "READ_ONLY"
#   db_proxy_endpoint_name = "rds-proxy-read-endpoint"
# }

# IAM role for RDS Proxy
# resource "aws_iam_role" "rds_proxy_role" {
#   name = "lookcard-rds-proxy-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = "sts:AssumeRole",
#         Effect = "Allow",
#         Principal = {
#           Service = "rds.amazonaws.com"
#         }
#       }
#     ]
#   })
# }


# Add the Secrets Manager policy for the RDS Proxy role
# resource "aws_iam_role_policy" "rds_proxy_secrets_policy" {
#   name   = "lookcard-rds-proxy-secrets-policy"
#   role   = aws_iam_role.rds_proxy_role.id
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Sid: "VisualEditor0",
#         Effect: "Allow",
#         Action: [
#           "secretsmanager:GetRandomPassword",
#           "secretsmanager:CreateSecret",
#           "secretsmanager:ListSecrets"
#         ],
#         Resource: "*"
#       },
#       {
#         Sid: "VisualEditor1",
#         Effect: "Allow",
#         Action: "secretsmanager:*",
#         Resource: [
#           "*"  # Replace with your actual secret ARN
#         ]
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "rds_proxy_role_policy" {
#   role       = aws_iam_role.rds_proxy_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
# }

# Define the security group

# IAM role and policy attachment for monitoring
# resource "aws_iam_role" "rds_monitoring_role" {
#   name = "rds-monitoring-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = "sts:AssumeRole",
#         Effect = "Allow",
#         Principal = {
#           Service = "monitoring.rds.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "rds_monitoring_role_policy" {
#   role       = aws_iam_role.rds_monitoring_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
# }
