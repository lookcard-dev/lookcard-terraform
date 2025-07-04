resource "aws_service_discovery_service" "discovery_service" {
  name = replace(var.name, "-", ".")
  dns_config {
    namespace_id = var.namespace_id
    dns_records {
      ttl  = 10
      type = "CNAME"
    }
  }

  # Point to ALB instead of service IPs
  tags = {
    ALB_DNS_NAME = var.elb.application_load_balancer_dns_name
  }
}

# Create a custom DNS record pointing to the ALB
resource "aws_service_discovery_instance" "alb_instance" {
  instance_id = "${var.name}-alb"
  service_id  = aws_service_discovery_service.discovery_service.id

  attributes = {
    AWS_INSTANCE_CNAME = var.elb.application_load_balancer_dns_name
  }
}

resource "aws_ecs_service" "ecs_service" {
  name            = var.name
  task_definition = aws_ecs_task_definition.task_definition.arn
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  desired_count = var.image_tag == "latest" ? 0 : (
    var.runtime_environment == "production" ? 2 : 1
  )
  cluster = var.cluster_id

  network_configuration {
    subnets         = var.network.private_subnet_ids
    security_groups = [aws_security_group.security_group.id]
  }

  # Attach to ALB target group
  load_balancer {
    target_group_arn = aws_lb_target_group.service_target_group.arn
    container_name   = var.name
    container_port   = 8080
  }

  # Keep service registries for backward compatibility if needed
  service_registries {
    registry_arn = aws_service_discovery_service.discovery_service.arn
  }

  lifecycle {
    ignore_changes = [
      capacity_provider_strategy
    ]
  }

  depends_on = [aws_lb_target_group.service_target_group]
}
