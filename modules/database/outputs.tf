# output "db_identifier" {
#   value = aws_rds_cluster_instance.lookcard_instance[*].identifier

# }

output "dynamodb_table_arn" {
  value = aws_dynamodb_table.websocket.arn
}