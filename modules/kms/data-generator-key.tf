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