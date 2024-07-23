resource "aws_kms_key" "data_encryption_key_beta" {
  description              = "KMS key for data encryption key beta"
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  deletion_window_in_days  = 30
  is_enabled               = true

  tags = {
    Name = "data_encryption_key_beta"
  }
}

resource "aws_kms_alias" "data_encryption_key_beta_alias" {
  name          = "alias/lookcard/data-encryption-key/beta"
  target_key_id = aws_kms_key.data_encryption_key_beta.id
}



