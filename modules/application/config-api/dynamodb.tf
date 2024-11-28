resource "aws_dynamodb_table" "config_api_config_data" {
  name           = "Config_API-Config_Data"
  billing_mode   = "PAY_PER_REQUEST"
  # read_capacity  = 2
  # write_capacity = 2
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

}