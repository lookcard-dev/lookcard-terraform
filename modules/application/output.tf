output "lookcard_api_domain" {
  value = aws_api_gateway_domain_name.lookcard_domain.domain_name
}
# output "kms_encryption_key_id_alpha_arn" {
#   value = aws_kms_key.data_encryption_key_alpha.arn
# }
# output "kms_generator_key_id_arn" {
#   value = aws_kms_key.data_generator_key.arn
# }
