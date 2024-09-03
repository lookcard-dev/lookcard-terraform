
resource "aws_ecs_cluster" "look_card" {
  name = "look_card"
  setting {
    name  = "containerInsights"
    value = var.ecs_cluster_config.enable ? "enabled" : "disabled"
  }
}

resource "aws_ecs_cluster" "admin_panel" {
  name = "admin_panel"
  setting {
    name  = "containerInsights"
    value = var.ecs_cluster_config.enable ? "enabled" : "disabled"
  }
}

resource "aws_ecs_cluster" "aml_tron" {
  name = "aml_tron"
  setting {
    name  = "containerInsights"
    value = var.ecs_cluster_config.enable ? "enabled" : "disabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "look_card" {
  cluster_name       = aws_ecs_cluster.look_card.name
  capacity_providers = ["FARGATE_SPOT"]
  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE_SPOT"
  }
}

resource "aws_ecs_cluster_capacity_providers" "admin_panel" {

  cluster_name       = aws_ecs_cluster.admin_panel.name
  capacity_providers = ["FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE_SPOT"

  }
}

resource "aws_ecs_cluster_capacity_providers" "aml_tron" {

  cluster_name       = aws_ecs_cluster.aml_tron.name
  capacity_providers = ["FARGATE_SPOT"]
  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE_SPOT"
  }
}

resource "aws_cloudwatch_log_group" "look_card_logs" {
  name              = "/ecs/look_card"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "admin_panel_logs" {
  name              = "/ecs/admin_panel"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "aml_tron_logs" {
  name              = "/ecs/aml_tron"
  retention_in_days = 30
}
