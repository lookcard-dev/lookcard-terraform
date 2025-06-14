# ECS Services for Supabase Components

# GoTrue (Authentication) ECS Service
resource "aws_ecs_service" "gotrue" {
  name            = "gotrue"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.gotrue.arn

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  desired_count = var.runtime_environment == "production" ? 2 : 1

  network_configuration {
    subnets         = var.network.private_subnet_ids
    security_groups = [aws_security_group.gotrue_sg.id]
  }

  service_registries {
    registry_arn = aws_service_discovery_service.gotrue.arn
  }

  lifecycle {
    ignore_changes = [
      capacity_provider_strategy
    ]
  }

  tags = {
    Name        = "supabase-gotrue"
    Environment = var.runtime_environment
  }
}

# PostgREST (REST API) ECS Service
resource "aws_ecs_service" "postgrest" {
  name            = "postgrest"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.postgrest.arn

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  desired_count = var.runtime_environment == "production" ? 2 : 1

  network_configuration {
    subnets         = var.network.private_subnet_ids
    security_groups = [aws_security_group.postgrest_sg.id]
  }

  service_registries {
    registry_arn = aws_service_discovery_service.postgrest.arn
  }

  lifecycle {
    ignore_changes = [
      capacity_provider_strategy
    ]
  }

  tags = {
    Name        = "postgrest"
    Environment = var.runtime_environment
  }
}

# Postgres Meta (Database Management) ECS Service
resource "aws_ecs_service" "postgres_meta" {
  name            = "postgres-meta"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.postgres_meta.arn

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  desired_count = var.runtime_environment == "production" ? 2 : 1

  network_configuration {
    subnets         = var.network.private_subnet_ids
    security_groups = [aws_security_group.postgres_meta_sg.id]
  }

  service_registries {
    registry_arn = aws_service_discovery_service.postgres_meta.arn
  }

  lifecycle {
    ignore_changes = [
      capacity_provider_strategy
    ]
  }

  tags = {
    Name        = "supabase-postgres-meta"
    Environment = var.runtime_environment
  }
}

# Kong (API Gateway) ECS Service
resource "aws_ecs_service" "kong" {
  name            = "kong"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.kong.arn

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  desired_count = var.runtime_environment == "production" ? 2 : 1

  network_configuration {
    subnets         = var.network.private_subnet_ids
    security_groups = [aws_security_group.kong_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.kong.arn
    container_name   = "kong"
    container_port   = 8000
  }

  service_registries {
    registry_arn = aws_service_discovery_service.kong.arn
  }

  lifecycle {
    ignore_changes = [
      capacity_provider_strategy
    ]
  }

  tags = {
    Name        = "supabase-kong"
    Environment = var.runtime_environment
  }
}
