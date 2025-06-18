resource "aws_dynamodb_table" "batch_account_statement_generator_unprocessed" {
  name         = "CronJob-Batch_Account_Statement_Generator_Unprocessed"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  range_key    = "cycle"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "cycle"
    type = "S"
  }

  global_secondary_index {
    name            = "id-cycle-index"
    hash_key        = "id"
    range_key       = "cycle"
    projection_type = "ALL"
  }
}

resource "aws_dynamodb_table" "batch_account_snapshot_processor_unprocessed" {
  name         = "CronJob-Batch_Account_Snapshot_Processor_Unprocessed"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  range_key    = "cycle"
  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "cycle"
    type = "S"
  }

  global_secondary_index {
    name            = "id-cycle-index"
    hash_key        = "id"
    range_key       = "cycle"
    projection_type = "ALL"
  }
}
