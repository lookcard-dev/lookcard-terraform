output "data_encryption_key_arn" {
  value = module.kms.data_encryption_key_arn
}

output "data_generator_key_arn" {
  value = module.kms.data_generator_key_arn
}

output "crypto_worker_alpha_key_arn" {
  value = module.kms.crypto_worker_alpha_key_arn
}

output "crypto_liquidity_key_arn" {
  value = module.kms.crypto_liquidity_key_arn
}

output "secret_arns" {
  value = module.secret.secret_arns
}

output "secret_ids" {
  value = module.secret.secret_ids
}