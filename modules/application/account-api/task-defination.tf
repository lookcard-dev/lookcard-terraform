resource "aws_ecs_task_definition" "account_api" {
  family                   = local.application.name
  network_mode             = "awsvpc"
  # requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  task_role_arn            = aws_iam_role.Account_API_Task_Role.arn
  execution_role_arn       = aws_iam_role.Account_API_Task_Execution_Role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name  = local.application.name
      image = "${local.application.image}:${local.application.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/${local.application.name}",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      secrets = local.ecs_task_secret_vars
      environment = local.ecs_task_env_vars
      portMappings = [
        {
          name          = "look-card-account-api-8080-tcp",
          containerPort = local.application.port,
          hostPort      = local.application.port,
          protocol      = "tcp",
          appProtocol   = "http",
        },
      ]
      readonlyRootFilesystem : true

      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:${local.application.port}/healthcheckz || exit 1"]
        interval    = 30   # seconds between health checks
        timeout     = 5    # health check timeout in seconds
        retries     = 3    # number of retries before marking container unhealthy
        startPeriod = 10   # time to wait before performing first health check
      }
    }
  ])
}
resource "aws_cloudwatch_log_group" "account_api" {
  name = "/ecs/${local.application.name}"
}


