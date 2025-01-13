resource "aws_dynamodb_table" "edns_api_domain_data" {
  name           = "EDNS_API-Domain_Data"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "key"

  attribute {
    name = "key"
    type = "S"
  }

  attribute {
    name = "ownerProfileId"
    type = "S"
  }

  global_secondary_index {
    name               = "ownerProfileId_index"
    hash_key          = "ownerProfileId"
    projection_type    = "ALL"
  }
}