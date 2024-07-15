resource "aws_service_discovery_service" "evvo_transaction_service" {
  name = "_transaction.api"

  dns_config {
    namespace_id = var.lookcardlocal_namespace_id

    dns_records {
      ttl  = 10
      type = "A"
    }
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}


resource "aws_ecs_service" "transaction" {
  name            = local.application.name
  task_definition = aws_ecs_task_definition.Transaction.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  cluster         = var.cluster

  network_configuration {
    subnets         = [var.network.private_subnet[0], var.network.private_subnet[1], var.network.private_subnet[2]]
    security_groups = [aws_security_group.transactionApi.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.transaction_api_target_group.arn
    container_name   = local.application.name
    container_port   = local.application.port
  }

  service_registries {
    registry_arn = aws_service_discovery_service.evvo_transaction_service.arn
  }
}




resource "aws_lb_target_group" "transaction_api_target_group" {
  name        = "Transaction-api"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.network.vpc
  target_type = "ip"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "transaction_api_listener_rule" {
  listener_arn = var.default_listener

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.transaction_api_target_group.arn
  }

  condition {
    path_pattern {
      values = local.load_balancer.api_path
    }
  }

  priority = local.load_balancer.priority
  tags = {
    Name = "transaction-api-listener-rule"
  }
}
