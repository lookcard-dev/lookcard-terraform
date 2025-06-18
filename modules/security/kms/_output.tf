output "data_encryption_key_id" {
  value = aws_kms_key.data_encryption_key.id
}

output "data_generator_key_id" {
  value = aws_kms_key.data_generator_key.id
}

output "data_encryption_key_arn" {
  value = aws_kms_key.data_encryption_key.arn
}

output "data_generator_key_arn" {
  value = aws_kms_key.data_generator_key.arn
}

output "crypto_worker_alpha_key_arn" {
  value = aws_kms_key.crypto_worker_alpha_key.arn
}

output "crypto_liquidity_key_arn" {
  value = aws_kms_key.crypto_liquidity_key.arn
}