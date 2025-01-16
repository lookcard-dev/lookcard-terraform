resource "aws_dynamodb_table" "wallet_nonce" {
  name           = "Crypto_API-Wallet_Nonce"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "alias"

  attribute {
    name = "alias"
    type = "S"
  }
}