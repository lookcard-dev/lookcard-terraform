resource "aws_service_discovery_private_dns_namespace" "api_lookcardlocal_namespace" {
  name = "api.lookcard.local"
  vpc  = var.network.vpc
}

resource "aws_ecs_service" "config_api" {
  name            = local.application.name
  task_definition = aws_ecs_task_definition.config-api.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  cluster         = var.cluster

  network_configuration {
    subnets         = [var.network.private_subnet[0], var.network.private_subnet[1], var.network.private_subnet[2]]
    security_groups = [aws_security_group.profile-api-sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.profile_api_target_group.arn
    container_name   = local.application.name
    container_port   = local.application.port
  }

  service_registries {
    registry_arn = aws_service_discovery_service.profile_service.arn
  }
}

resource "aws_lb_target_group" "profile_api_target_group" {
  name        = local.application.name
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.network.vpc
  health_check {
    interval            = 30
    path                = "/healthcheckz"
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}


resource "aws_lb_listener_rule" "profile_api_listener_signer_rule" {
  listener_arn = var.default_listener

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.profile_api_target_group.arn
  }

  condition {
    path_pattern {
      values = local.load_balancer.signer_api_path
    }
  }

  priority = local.load_balancer.signer_priority
  tags = {
    Name = "profile-api-signer-listener-rule"
  }
}

resource "aws_lb_listener_rule" "crypto_api_listener_blockchain_rule" {
  listener_arn = var.default_listener

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.crypto_api_target_group.arn
  }

  condition {
    path_pattern {
      values = local.load_balancer.blockchain_api_path
    }
  }

  priority = local.load_balancer.blockchain_priority
  tags = {
    Name = "crypto-api-blockchain-listener-rule"
  }
}

resource "aws_lb_listener_rule" "crypto_api_listener_hdwallet_rule" {
  listener_arn = var.default_listener

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.crypto_api_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/hd-wallet"]
    }
  }

  priority = local.load_balancer.hdwallet_priority
  tags = {
    Name = "crypto-api-hdwallet-listener-rule"
  }
}




