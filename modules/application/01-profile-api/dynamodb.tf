resource "aws_dynamodb_table" "profile" {
  name         = "Profile_API-Profile"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "principal"
    type = "S"
  }

  global_secondary_index {
    name               = "principal-index"
    hash_key           = "principal"
    projection_type    = "ALL"
  }
}