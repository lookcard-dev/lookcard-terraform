resource "aws_dynamodb_table" "batch_account_statement_generator_history" {
  name         = "CronJob-Batch_Account_Statement_Generator_History"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  range_key    = "timestamp"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "S"
  }
}

resource "aws_dynamodb_table" "batch_account_snapshot_processor_history" {
  name         = "CronJob-Batch_Account_Snapshot_Processor_History"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  range_key    = "timestamp"
  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "S"
  }
}
