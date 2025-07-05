resource "aws_ecs_task_definition" "task_definition" {
  family             = var.name
  network_mode       = "awsvpc"
  cpu                = "512"
  memory             = "1024"
  task_role_arn      = aws_iam_role.task_role.arn
  execution_role_arn = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "ARM64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name  = var.name
      image = "fusionauth/fusionauth-app:1.57.1"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/${var.name}",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = [
        {
          name  = "DATABASE_URL"
          value = "jdbc:postgresql://${var.datastore.writer_endpoint}:5432/fusionauth"
        },
        {
          name  = "FUSIONAUTH_APP_RUNTIME_MODE"
          value = "production"
        },
        {
          name  = "SEARCH_TYPE"
          value = "database"
        },
        {
          name  = "FUSIONAUTH_APP_HTTP_PORT",
          value = "9011"
        }
      ]
      secrets = [
        {
          name      = "DATABASE_USERNAME"
          valueFrom = "${var.secret_arns["DATABASE"]}:username::"
        },
        {
          name      = "DATABASE_PASSWORD"
          valueFrom = "${var.secret_arns["DATABASE"]}:password::"
        },
        {
          name      = "DATABASE_ROOT_USERNAME"
          valueFrom = "${var.secret_arns["DATABASE"]}:username::"
        },
        {
          name      = "DATABASE_ROOT_PASSWORD"
          valueFrom = "${var.secret_arns["DATABASE"]}:password::"
        },
      ]
      portMappings = [
        {
          name          = "9011-tcp",
          containerPort = 9011,
          hostPort      = 9011,
          protocol      = "tcp",
          appProtocol   = "http",
        },
      ]

      healthCheck = {
        command     = ["CMD-SHELL", "curl --silent --fail http://localhost:9011/api/status || exit 1"]
        interval    = 30 # seconds between health checks
        timeout     = 5  # health check timeout in seconds
        retries     = 3  # number of retries before marking container unhealthy
        startPeriod = 10 # time to wait before performing first health check
      }
    },
    # {
    #   name  = "cloudflared"
    #   image = "cloudflared/cloudflared:latest"
    #   logConfiguration = {
    #     logDriver = "awslogs",
    #     options = {
    #       "awslogs-create-group"  = "true",
    #       "awslogs-group"         = "/ecs/${var.name}",
    #       "awslogs-region"        = "ap-southeast-1",
    #       "awslogs-stream-prefix" = "cloudflared",
    #     }
    #   }
    #   essential = true
    #   command = [
    #     "tunnel",
    #     "--no-autoupdate",
    #     "run",
    #     "--token",
    #     random_password.tunnel_secret.result
    #   ]
    # }
  ])
}
