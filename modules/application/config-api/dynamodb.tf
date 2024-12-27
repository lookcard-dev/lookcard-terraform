resource "aws_dynamodb_table" "config_api_config_data" {
  name           = "Config_API-Config_Data"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "key"

  attribute {
    name = "key"
    type = "S"
  }
}

resource "aws_dynamodb_table" "config_api_config_history" {
  name           = "Config_API-Config_History"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "key"
  range_key      = "timestamp"

  attribute {
    name = "key"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "S"
  }
}