resource "aws_kms_key" "data_encryption_key" {
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  deletion_window_in_days  = 30
  is_enabled               = true
}

resource "aws_kms_alias" "data_encryption_key_alias" {
  name          = "alias/lookcard/data-encryption-key"
  target_key_id = aws_kms_key.data_encryption_key.id
}

resource "aws_kms_key" "data_generator_key" {
  description              = "KMS key for data generator key"
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  deletion_window_in_days  = 30
  is_enabled               = true

  tags = {
    Name = "data_generator_key"
  }
}

resource "aws_kms_alias" "data_generator_key_alias" {
  name          = "alias/lookcard/data-generator-key"
  target_key_id = aws_kms_key.data_generator_key.id
}

resource "aws_kms_key" "crypto_worker_alpha_key" {
  key_usage                = "SIGN_VERIFY"
  customer_master_key_spec = "ECC_SECG_P256K1"
  deletion_window_in_days  = 30
  is_enabled               = true
}

resource "aws_kms_alias" "crypto_worker_alpha_key_alias" {
  name          = "alias/lookcard/crypto/worker/alpha"
  target_key_id = aws_kms_key.crypto_worker_alpha_key.id
}

resource "aws_kms_key" "crypto_liquidity_key" {
  key_usage                = "SIGN_VERIFY"
  customer_master_key_spec = "ECC_SECG_P256K1"
  deletion_window_in_days  = 30
  is_enabled               = true
}

resource "aws_kms_alias" "crypto_liquidity_key_alias" {
  name          = "alias/lookcard/crypto/liquidity"
  target_key_id = aws_kms_key.crypto_liquidity_key.id
}

resource "aws_kms_key" "crypto_withdrawal_alpha_key" {
  key_usage                = "SIGN_VERIFY"
  customer_master_key_spec = "ECC_SECG_P256K1"
  deletion_window_in_days  = 30
  is_enabled               = true
}

resource "aws_kms_alias" "crypto_withdrawal_alpha_key_alias" {
  name          = "alias/lookcard/crypto/withdrawal/alpha"
  target_key_id = aws_kms_key.crypto_withdrawal_alpha_key.id
}