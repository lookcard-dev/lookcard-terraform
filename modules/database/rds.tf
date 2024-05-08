# resource "random_password" "master_password" {
#   length           = 16
#   special          = true
#   override_special = "!@%^&*()-_=+[]{}|;:,.<>?`~"
# }

# resource "aws_secretsmanager_secret" "lookcard_db_secret" {
#   name = "look-card_db_master_password"
# }

# resource "aws_secretsmanager_secret_version" "lookcard_db_secret_version" {
#   secret_id     = aws_secretsmanager_secret.lookcard_db_secret.id
#   secret_string = random_password.master_password.result
# }

# resource "aws_db_subnet_group" "lookcard_rds_subnet" {
#   name       = "lookcard_rds_subnet"
#   subnet_ids = [var.Database-Sub-1[0], var.Database-Sub-2[1], var.Database-Sub-3[2]]
# }

# resource "aws_rds_cluster" "lookcard" {
#   cluster_identifier     = "look-uat-database"
#   database_name          = "lookcarduat"
#   engine                 = "aurora-postgresql" # Change to aurora-postgresql
#   engine_version         = "16.1"              # Change to a supported version of PostgreSQL
#   master_username        = "lookcard"
#   master_password        = aws_secretsmanager_secret_version.lookcard_db_secret_version.secret_string
#   skip_final_snapshot    = false
#   db_subnet_group_name   = aws_db_subnet_group.lookcard_rds_subnet.name
#   vpc_security_group_ids = [var.rds_security_group-1]
#   port                   = 5443
#   deletion_protection    = true # Enable deletion protection
#   storage_encrypted      = true


# }



# resource "aws_rds_cluster_instance" "lookcard_instance" {
#   count               = 1
#   identifier          = "lookcard-database-instance-${count.index}"
#   cluster_identifier  = aws_rds_cluster.lookcard.id
#   instance_class      = "db.t4g.medium"     # Adjust as needed
#   engine              = "aurora-postgresql" # Change to aurora-postgresql
#   publicly_accessible = false
# }
