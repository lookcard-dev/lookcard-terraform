resource "random_password" "master_password" {
  length           = 16
  special          = true
  override_special = "!@%^&*()-_=+[]{}|;:,.<>?`~"
}

resource "aws_secretsmanager_secret_version" "lookcard_db_secret_version" {
  secret_id     = var.lookcard_db_secret
  secret_string = random_password.master_password.result
}

resource "aws_db_subnet_group" "lookcard_rds_subnet" {
  name       = "lookcard_rds_subnet"
  subnet_ids = [var.network.private_subnet[0], var.network.private_subnet[1], var.network.private_subnet[2]] 
}

resource "aws_rds_cluster" "lookcard" {
  cluster_identifier     = "lookcard-testing-db"
  database_name          = "lookcardtest"
  engine                 = "aurora-postgresql"
  engine_version         = "16.1"
  master_username        = "lookcard"
  master_password        = aws_secretsmanager_secret_version.lookcard_db_secret_version.secret_string
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.lookcard_rds_subnet.name
  vpc_security_group_ids = [aws_security_group.look-card-db.id]
  port                   = 5443
  deletion_protection    = true
  storage_encrypted      = true
}

resource "aws_rds_cluster_instance" "lookcard_instance" {
  count                        = 1
  identifier                   = "lookcard-database-instance-${count.index}"
  cluster_identifier           = aws_rds_cluster.lookcard.id
  instance_class               = count.index == 0 ? "db.t4g.large" : "db.r6g.large"
  engine                       = "aurora-postgresql"
  publicly_accessible          = false
  availability_zone            = element(["ap-southeast-1a", "ap-southeast-1b"], count.index)
  performance_insights_enabled = true
  monitoring_interval          = 60
  monitoring_role_arn          = aws_iam_role.rds_monitoring_role.arn
}

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

resource "aws_security_group" "look-card-db" {
  name        = "Database-Security-Group"
  description = "Security group for ECS services"
  vpc_id      = var.network.vpc

  ingress {
    from_port   = 5443
    to_port     = 5443
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









# resource "random_password" "master_password" {
#   length           = 16
#   special          = true
#   override_special = "!@%^&*()-_=+[]{}|;:,.<>?`~"
# }

# # resource "aws_secretsmanager_secret" "lookcard_db_secret" {
# #   name = "look-card_db_master_password"
# # }

# resource "aws_secretsmanager_secret_version" "lookcard_db_secret_version" {
# #   secret_id     = aws_secretsmanager_secret.lookcard_db_secret.id
#   secret_id     = var.lookcard_db_secret
#   secret_string = random_password.master_password.result
# }

# resource "aws_db_subnet_group" "lookcard_rds_subnet" {
#   name       = "lookcard_rds_subnet"
#   subnet_ids = [var.network.private_subnet[0], var.network.private_subnet[1], var.network.private_subnet[2]] 
# }


# resource "aws_rds_cluster" "lookcard" {
#   cluster_identifier     = "look-production-db"
#   database_name          = "lookcardprod"
#   engine                 = "aurora-postgresql" # Change to aurora-postgresql
#   engine_version         = "16.1"              # Change to a supported version of PostgreSQL
#   master_username        = "lookcard"
#   master_password        = aws_secretsmanager_secret_version.lookcard_db_secret_version.secret_string
#   skip_final_snapshot    = false
#   db_subnet_group_name   = aws_db_subnet_group.lookcard_rds_subnet.name
#   vpc_security_group_ids = [aws_security_group.look-card-db.id]
#   port                   = 5443
#   deletion_protection    = true # Enable deletion protection
#   storage_encrypted      = true



# }

# resource "aws_rds_cluster_instance" "lookcard_instance" {
#   count                        = 2
#   identifier                   = "lookcard-database-instance-${count.index}"
#   cluster_identifier           = aws_rds_cluster.lookcard.id
#   instance_class               = count.index == 0 ? "db.t4g.large" : "db.r6g.large" # Adjust as needed
#   engine                       = "aurora-postgresql"                                # Change to aurora-postgresql
#   publicly_accessible          = false
#   availability_zone            = element(["ap-southeast-1a", "ap-southeast-1b"], count.index)
#   performance_insights_enabled = true
#   monitoring_interval = 60
# }


# resource "aws_security_group" "look-card-db" {
#   name        = "Database-Security-Group"
#   description = "Security group for ECS services"
#   vpc_id      = var.network.vpc


#   ingress {
#     from_port       = 5443
#     to_port         = 5443
#     protocol        = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     # security_groups = [aws_security_group.Authentication.id, aws_security_group.Blockchain.id, aws_security_group.Card.id, aws_security_group.Notification.id, aws_security_group.Reporting.id, aws_security_group.Transantion.id, aws_security_group.Users.id, aws_security_group.Utility.id, aws_security_group.AML_Tron.id, aws_security_group.Crypto-API-SG.id,aws_security_group.Account-API-SG.id ]
#   }

#   ingress {
#     from_port       = 5443
#     to_port         = 5443
#     protocol        = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     # security_groups = [aws_security_group.data_process.id, aws_security_group.eliptic.id, aws_security_group.Push_Notification.id, aws_security_group.Withdrawal.id, aws_security_group.isolated.id, aws_security_group.isolated-1.id]
#   }

#   ingress {
#     from_port   = 5443
#     to_port     = 5443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "look-card-DB-sg"
#   }
# }