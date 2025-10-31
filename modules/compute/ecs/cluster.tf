resource "aws_ecs_cluster" "listener" {
  name = "listener"
  setting {
    name  = "containerInsights"
    value = var.runtime_environment == "production" ? "enabled" : "disabled"
  }
}

resource "aws_ecs_cluster" "administrative" {
  name = "administrative"
  setting {
    name  = "containerInsights"
    value = var.runtime_environment == "production" ? "enabled" : "disabled"
  }
}

resource "aws_ecs_cluster" "composite_application" {
  name = "composite-application"
  setting {
    name  = "containerInsights"
    value = var.runtime_environment == "production" ? "enhanced" : "disabled"
  }
}

resource "aws_ecs_cluster" "core_application" {
  name = "core-application"
  setting {
    name  = "containerInsights"
    value = var.runtime_environment == "production" ? "enhanced" : "disabled"
  }
}

resource "aws_ecs_cluster" "cronjob" {
  name = "cronjob"
  setting {
    name  = "containerInsights"
    value = var.runtime_environment == "production" ? "enabled" : "disabled"
  }
}

resource "aws_ecs_cluster" "authentication" {
  name = "authentication"
  setting {
    name  = "containerInsights"
    value = var.runtime_environment == "production" ? "enabled" : "disabled"
  }
}
