output "listener_cluster_id"{
    value = aws_ecs_cluster.listener.id
}

output "core_application_cluster_id"{
    value = aws_ecs_cluster.core_application.id
}

output "composite_application_cluster_id"{
    value = aws_ecs_cluster.composite_application.id
}

output "administrative_cluster_id"{
    value = aws_ecs_cluster.administrative.id
}

output "webhook_cluster_id"{
    value = aws_ecs_cluster.webhook.id
}