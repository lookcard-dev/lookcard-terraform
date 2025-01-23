resource "aws_dynamodb_table" "data" {
  name         = "Config_API-Data"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "key"

  attribute {
    name = "key"
    type = "S"
  }
}

resource "aws_dynamodb_table" "history" {
  name         = "Config_API-History"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "key"
  range_key    = "timestamp"

  attribute {
    name = "key"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "N"
  }
}
