
resource "aws_ecs_cluster" "application" {
  name = "application"
  setting {
    name  = "containerInsights"
    value = var.ecs_cluster_config.enable ? "enabled" : "disabled"
  }
}

resource "aws_ecs_cluster" "listener" {
  name = "listener"
  setting {
    name  = "containerInsights"
    value = var.ecs_cluster_config.enable ? "enabled" : "disabled"
  }
}

resource "aws_ecs_cluster" "admin" {
  name = "admin"
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

resource "aws_ecs_capacity_provider" "ec2_arm64_on_demand" {
  name = "EC2_ARM64_ON_DEMAND"

  auto_scaling_group_provider {
    auto_scaling_group_arn = module.transaction-listener.transaction_listener_arm64_asg_arn
  }
}

resource "aws_ecs_capacity_provider" "ec2_amd64_on_demand" {
  name = "EC2_AMD64_ON_DEMAND"

  auto_scaling_group_provider {
    auto_scaling_group_arn = module.transaction-listener.transaction_listener_amd64_asg_arn
  }
}

resource "aws_ecs_cluster_capacity_providers" "application" {
  cluster_name       = aws_ecs_cluster.application.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE_SPOT"
  }
}

resource "aws_ecs_cluster_capacity_providers" "listener" {
  cluster_name       = aws_ecs_cluster.listener.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT", aws_ecs_capacity_provider.ec2_amd64_on_demand.name, aws_ecs_capacity_provider.ec2_arm64_on_demand.name]
  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE_SPOT"
  }
}

resource "aws_ecs_cluster_capacity_providers" "admin" {

  cluster_name       = aws_ecs_cluster.admin.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

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

resource "aws_cloudwatch_log_group" "admin_logs" {
  name              = "/ecs/admin"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "aml_tron_logs" {
  name              = "/ecs/aml_tron"
  retention_in_days = 30
}
