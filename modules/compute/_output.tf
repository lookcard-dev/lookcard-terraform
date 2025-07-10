output "listener_cluster_id" {
  value = module.ecs.listener_cluster_id
}

output "listener_security_group_id" {
  value = module.ecs.listener_security_group_id
}

output "core_application_cluster_id" {
  value = module.ecs.core_application_cluster_id
}

output "composite_application_cluster_id" {
  value = module.ecs.composite_application_cluster_id
}

output "administrative_cluster_id" {
  value = module.ecs.administrative_cluster_id
}

output "cronjob_cluster_id" {
  value = module.ecs.cronjob_cluster_id
}

output "authentication_cluster_id" {
  value = module.ecs.authentication_cluster_id
}
