output "kms_data_encryption_key_id_alpha" {
  value = aws_kms_key.data_encryption_key_beta.id
}

# output "kms_data_encryption_key_alpha_arn" {
#   value = aws_kms_key.data_encryption_key_alpha.arn
# }

output "kms_data_encryption_key_id_beta" {
  value = aws_kms_key.data_encryption_key_beta.id
}

output "kms_data_encryption_key_id_charlie" {
  value = aws_kms_key.data_encryption_key_charlie.id
}

output "kms_data_encryption_key_id_delta" {
  value = aws_kms_key.data_encryption_key_delta.id
}

output "kms_data_encryption_key_id_echo" {
  value = aws_kms_key.data_encryption_key_echo.id
}