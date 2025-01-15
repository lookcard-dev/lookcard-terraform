output "kms_data_generator_key_id" {
  value = aws_kms_key.data_generator_key
}

# output "kms_data_encryption_key_alpha_arn" {
#   value = module.data_encryption_key.kms_data_encryption_key_id_alpha.arn
# }

output "kms_data_encryption_key_id_alpha" {
  value = module.data_encryption_key.kms_data_encryption_key_id_alpha
}

output "kms_data_encryption_key_id_beta" {
  value = module.data_encryption_key.kms_data_encryption_key_id_beta
}

output "kms_data_encryption_key_id_charlie" {
  value = module.data_encryption_key.kms_data_encryption_key_id_charlie
}

output "kms_data_encryption_key_id_delta" {
  value = module.data_encryption_key.kms_data_encryption_key_id_delta
}

output "kms_data_encryption_key_id_echo" {
  value = module.data_encryption_key.kms_data_encryption_key_id_echo
}