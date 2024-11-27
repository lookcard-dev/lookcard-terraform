output "s3_lookcard_log_bucket" {
  value = module.s3.lookcard_log_bucket
}

output "redis_host" {
  value = module.cache.redis_host
}

output "rds_aurora_postgresql_writer_endpoint" {
  value = module.database.rds_aurora_postgresql_writer_endpoint
}

output "rds_aurora_postgresql_reader_endpoint" {
  value = module.database.rds_aurora_postgresql_reader_endpoint
}
