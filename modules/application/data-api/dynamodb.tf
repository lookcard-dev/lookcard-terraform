resource "aws_dynamodb_table" "data_api_data" {
  name           = "Data_API-Data"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}