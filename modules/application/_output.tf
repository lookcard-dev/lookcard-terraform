output "datastore_access_security_group_ids" {
  value = [
    module.user-api.security_group_id,
    module.account-api.security_group_id,
    module.crypto-api.security_group_id,
    module.referral-api.security_group_id,
    module.verification-api.security_group_id,
    module.reseller-api.security_group_id,
  ]
}

output "datacache_access_security_group_ids" {
  value = [
    module.user-api.security_group_id,
    module.account-api.security_group_id,
    module.crypto-api.security_group_id,
    module.referral-api.security_group_id,
    module.verification-api.security_group_id,
    module.reseller-api.security_group_id,
  ]
}
