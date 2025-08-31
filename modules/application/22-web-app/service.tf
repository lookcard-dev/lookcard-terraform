resource "aws_service_discovery_service" "discovery_service" {
  name = replace(var.name, "-", ".")
  
  dns_config {
    namespace_id = var.namespace_id
    dns_records {
      ttl  = 10
      type = "A"
    }
  }

  tags = {
    Name        = "${var.name}-service-discovery"
    Environment = var.runtime_environment
  }
}

resource "aws_ecs_service" "ecs_service" {
  name            = var.name
  task_definition = aws_ecs_task_definition.task_definition.arn
  cluster         = var.cluster_id
  launch_type     = "FARGATE"

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  desired_count = var.image_tag == "latest" ? 0 : (
    var.runtime_environment == "production" ? 2 : 1
  )

  network_configuration {
    subnets          = var.network.private_subnet_ids
    security_groups  = [aws_security_group.security_group.id]
    assign_public_ip = false
  }

  service_registries {
    registry_arn = aws_service_discovery_service.discovery_service.arn
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.service_target_group.arn
    container_name   = var.name
    container_port   = 3000
  }

  # Ensure target group is created before service
  depends_on = [aws_lb_target_group.service_target_group]

  lifecycle {
    ignore_changes = [
      capacity_provider_strategy
    ]
  }

  tags = {
    Name        = "${var.name}-service"
    Environment = var.runtime_environment
  }
}