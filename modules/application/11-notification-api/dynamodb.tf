resource "aws_dynamodb_table" "web_push_subscription" {
  name         = "Notification_API-Web_Push_Subscription"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  range_key    = "ownerProfileId"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "ownerProfileId"
    type = "S"
  }

  global_secondary_index {
    name            = "ownerProfileId-index"
    hash_key        = "ownerProfileId"
    projection_type = "ALL"
  }
}
