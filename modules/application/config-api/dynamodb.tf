resource "aws_dynamodb_table" "config_api_config_data" {
  name           = "Config_API-Config_Data"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "key"

  attribute {
    name = "key"
    type = "S"
  }
}