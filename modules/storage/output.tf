output "s3_lookcard_log_bucket" {
  value = module.s3.lookcard_log_bucket
}

output "redis_host" {
  value = module.cache.redis_host
}