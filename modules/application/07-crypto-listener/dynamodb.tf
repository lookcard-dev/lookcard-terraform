resource "aws_dynamodb_table" "block_recorder" {
  name         = "Crypto_Listener-Block_Recorder"
  billing_mode = "PROVISIONED"
  read_capacity  = 10
  write_capacity = 10
  hash_key     = "node"
  range_key    = "number"

  attribute {
    name = "node"
    type = "S"
  }

  attribute {
    name = "number"
    type = "N"
  }
}

resource "aws_dynamodb_table" "guard_recorder" {
  name         = "Crypto_Listener-Guard_Recorder"
  billing_mode = "PROVISIONED"
  read_capacity  = 2
  write_capacity = 2
  hash_key     = "node"

  attribute {
    name = "node"
    type = "S"
  }
}
