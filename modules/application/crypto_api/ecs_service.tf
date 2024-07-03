resource "aws_service_discovery_service" "crypto_service" {
  name = "crypto"

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

resource "aws_ecs_service" "crypto_api" {
  name            = "crypto-api"
  task_definition = aws_ecs_task_definition.crypto-api.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  cluster         = var.cluster

  network_configuration {
    subnets         = [var.network.private_subnet[0], var.network.private_subnet[1], var.network.private_subnet[2]]
    security_groups = [aws_security_group.crypto-api-sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.crypto_api_target_group.arn
    container_name   = "crypto-api"
    container_port   = 8080
  }

  service_registries {
    registry_arn = aws_service_discovery_service.crypto_service.arn
  }
}

resource "aws_lb_target_group" "crypto_api_target_group" {
  name        = "crypto-api"
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


resource "aws_lb_listener_rule" "crypto_api_listener_signer_rule" {
  listener_arn = var.default_listener

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.crypto_api_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/signer", "/signers", "/signer/*"]
    }
  }

  priority = 10
  tags = {
    Name = "crypto-api-signer-listener-rule"
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
      values = ["/blockchain", "/blockchain/*", "/blockchains"]
    }
  }

  priority = 101
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

  priority = 100
  tags = {
    Name = "crypto-api-hdwallet-listener-rule"
  }
}




