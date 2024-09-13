# output "db_identifier" {
#   value = aws_rds_cluster_instance.lookcard_instance[*].identifier

# }

output "ddb_websocket" {
  value = aws_dynamodb_table.websocket
}

output "dynamodb_crypto_transaction_listener_arn" {
  value = aws_dynamodb_table.crypto-transaction-listener.arn
}

output "dynamodb_config_api_config_data_name" {
  value = aws_dynamodb_table.config_api_config_data.name
}
output "dynamodb_config_api_config_data_arn" {
  value = aws_dynamodb_table.config_api_config_data.arn
}

output "dynamodb_profile_data_table_name" {
  value = aws_dynamodb_table.profile_data.name
}
output "dynamodb_data_api_data_table_name" {
  value = aws_dynamodb_table.data_api_data.name
}

output "rds_aurora_postgresql_writer_endpoint" {
  value = aws_rds_cluster.lookcard_develop.endpoint
}

output "rds_aurora_postgresql_reader_endpoint" {
  value = aws_rds_cluster.lookcard_develop.reader_endpoint
}