output "listener_cluster_id"{
    value = module.ecs.listener_cluster_id
}

output "core_application_cluster_id"{
    value = module.ecs.core_application_cluster_id
}

output "composite_application_cluster_id"{
    value = module.ecs.composite_application_cluster_id
}

output "administrative_cluster_id"{
    value = module.ecs.administrative_cluster_id
}

output "webhook_cluster_id"{
    value = module.ecs.webhook_cluster_id
}