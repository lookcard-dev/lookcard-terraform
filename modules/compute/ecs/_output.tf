output "listener_cluster_id"{
    value = aws_ecs_cluster.listener.id
}

output "listener_security_group_id"{
    value = aws_security_group.ec2_cluster_security_group.id
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

output "cronjob_cluster_id"{
    value = aws_ecs_cluster.cronjob.id
}