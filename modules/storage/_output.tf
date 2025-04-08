output "datastore_writer_endpoint" {
  value = module.datastore.writer_endpoint
}

output "datastore_reader_endpoint" {
  value = module.datastore.reader_endpoint
}

output "datacache_endpoint" {
  value = module.datacache.endpoint
}

output "data_bucket_arn" {
  value = module.s3.data_bucket_arn
}

output "data_bucket_name" {
  value = module.s3.data_bucket_name
}

output "log_bucket_arn" {
  value = module.s3.log_bucket_arn
}

output "log_bucket_name" {
  value = module.s3.log_bucket_name
}

output "datastore_cluster_security_group_id" {
  value = module.datastore.cluster_security_group_id
}

output "datastore_proxy_security_group_id" {
  value = module.datastore.proxy_security_group_id
}

output "datacache_security_group_id" {
  value = module.datacache.security_group_id
}

output "ecr_repository_urls" {
  value = module.ecr.repository_urls
}
