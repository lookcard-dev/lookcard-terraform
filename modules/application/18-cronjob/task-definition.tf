data "aws_ecr_repository" "repository" {
  name = var.name
}

data "aws_ecr_repository" "account_api" {
  name = "account-api"
}

resource "aws_ecs_task_definition" "batch_account_statement_generator_task_definition" {
  family                   = "cronjob-batch_account_statement_generator"
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
      name  = "generator"
      image = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/cronjob/batch_account_generator",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      readonlyRootFilesystem = true
      environment = [
        {
          name  = "AWS_CLOUDWATCH_LOG_GROUP_NAME"
          value = "/lookcard/cronjob/batch_account_statement_generator"
        },
      ]
      secrets = [{
        name      = "SENTRY_DSN"
          valueFrom = "${data.aws_secretsmanager_secret.sentry.arn}:CRONJOB_DSN::"
      }]
    },
    {
      name  = "account-api"
      image = "${data.aws_ecr_repository.account_api.repository_url}:${var.api_image_tags.account_api}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/cronjob/account-api",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      readonlyRootFilesystem = true
      environment = concat(local.environment_variables, [
        {
          name  = "AWS_CLOUDWATCH_LOG_GROUP_NAME"
          value = "/lookcard/cronjob/account-api"
        },
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "SENTRY_DSN"
          valueFrom = "${data.aws_secretsmanager_secret.sentry.arn}:ACCOUNT_API_DSN::"
        },
      ])
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