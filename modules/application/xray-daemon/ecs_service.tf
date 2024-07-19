resource "aws_service_discovery_service" "xray_daemon_service" {
  name = "xray.daemon"
  dns_config {
    namespace_id = var.lookcardlocal_namespace
    dns_records {
      ttl  = 10
      type = "A"
    }
  }
  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_ecs_service" "xray_daemon" {
  name            = "xray-daemon"
  cluster         = var.cluster
  task_definition = aws_ecs_task_definition.xray_daemon.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [var.network.private_subnet[0], var.network.private_subnet[1], var.network.private_subnet[2]]
    security_groups = [aws_security_group.xray_daemon_sg.id]
  }

#   service_registries {
#     registry_arn = aws_service_discovery_service.xray_daemon.arn
#   }
    service_registries {
    registry_arn   = aws_service_discovery_service.xray_daemon_service.arn
  }
}
