data "aws_ecr_repository" "repository" {
  name = var.name
}

# data "aws_ecr_image" "latest" {
#   repository_name = data.aws_ecr_repository.repository.name
#   most_recent     = true
# }

# locals {
#   image_exists = try(data.aws_ecr_image.latest.id != "", false)
#   container_image = local.image_exists ? "${data.aws_ecr_repository.repository.repository_url}@${data.aws_ecr_image.latest[0].id}" : "${data.aws_ecr_repository.repository.repository_url}:latest"
# }

resource "aws_ecs_task_definition" "task_definition" {
  family                   = var.name
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name  = var.name
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/${var.name}",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = local.environment_variables
      secrets = local.environment_secrets
      portMappings = [
        {
          name          = "8080-tcp",
          containerPort = 8080,
          hostPort      = 8080,
          protocol      = "tcp",
          appProtocol   = "http",
        },
      ]
      readonlyRootFilesystem = true

      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:8080/healthcheckz || exit 1"]
        interval    = 30   # seconds between health checks
        timeout     = 5    # health check timeout in seconds
        retries     = 3    # number of retries before marking container unhealthy
        startPeriod = 10   # time to wait before performing first health check
      }
    }
  ])
}
