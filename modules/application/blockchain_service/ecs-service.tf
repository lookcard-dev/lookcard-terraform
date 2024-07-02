resource "aws_service_discovery_service" "evvo_blockchain_service" {
  name = "_blockchain"

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

resource "aws_ecs_service" "blockchain" {
  name            = "Blockchain"
  task_definition = aws_ecs_task_definition.Blockchain.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  cluster         = var.cluster

  network_configuration {
    subnets          = [var.network.private_subnet[0], var.network.private_subnet[1], var.network.private_subnet[2]]
    security_groups  = [aws_security_group.blockchain.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.blockchain_target_group.arn
    container_name   = "Blockchain"
    container_port   = "3000"
  }

  service_registries {
    registry_arn = aws_service_discovery_service.evvo_blockchain_service.arn
  }
}

resource "aws_lb_target_group" "blockchain_target_group" {
  name        = "blockchain"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.network.vpc
}


resource "aws_lb_listener_rule" "blockchain_listener_rule" {
  listener_arn = var.default_listener

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blockchain_target_group.arn
  }
  condition {
    path_pattern {
      values = ["/v2/api/blc-s1umi0pnk/*"] # Wildcard path condition to match all requests
    }
  }
  priority = 3
  tags = {
    Name = "Blockchain_listener_rule"
    # Add more tags as needed
  }
}


resource "aws_security_group" "blockchain" {
  depends_on  = [var.network]
  name        = "Blockchain-Service-Security-Group"
  description = "Security group for ECS services"
  vpc_id      = var.network.vpc

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }



  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Blockchain-Serurity-Group"
  }
}
