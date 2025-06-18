resource "aws_dynamodb_table" "profile" {
  name         = "Reseller_API-Profile"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}