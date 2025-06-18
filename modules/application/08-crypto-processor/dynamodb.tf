resource "aws_dynamodb_table" "transaction_monitoring_result" {
  name         = "Crypto_Processor-Transaction_Monitoring_Result"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}
