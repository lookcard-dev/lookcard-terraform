# output "db_identifier" {
#   value = aws_rds_cluster_instance.lookcard_instance[*].identifier

# }

output "ddb_websocket" {
  value = aws_dynamodb_table.websocket
}

output "dynamodb_crypto_transaction_listener_arn" {
  value = aws_dynamodb_table.crypto-transaction-listener.arn
}

