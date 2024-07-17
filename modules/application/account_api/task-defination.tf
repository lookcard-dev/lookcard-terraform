resource "aws_ecs_task_definition" "Account_API" {
  family                   = local.application.name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  task_role_arn            = aws_iam_role.Account_API_Task_Role.arn
  execution_role_arn       = aws_iam_role.Account_API_Task_Execution_Role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  volume {
    name = "data"
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
      environment = [
        {
          name  = "CRYPTO_API_URL"
          value = "https://api.develop.not-lookcard.com"
        },
        {
          name  = "DATABASE_NAME"
          value = "main"
        },
        {
          name  = "DATABASE_SCHEMA"
          value = "account"
        },
        {
          name  = "SQS_NOTIFICATION_QUEUE_URL"
          value = var.sqs.lookcard_notification_queue_url
        },
        {
          name  = "SQS_ACCOUNT_WITHDRAWAL_QUEUE_URL"
          value = var.sqs.crypto_fund_withdrawal_queue_url
        },
        {
          name  = "DATABASE_ARGS"
          value = "sslmode=require"
        },
        # {
        #   name  = "AWS_XRAY_DAEMON_ENDPOINT"
        #   value = "xray.daemon.lookcard.local:2337"
        # }

      ]
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
      mountPoints = [
        {
          sourceVolume  = "data",
          containerPath = "/usr/src/data",
        },
      ]
    }
  ])
}

resource "aws_cloudwatch_log_group" "Account_API" {
  name = "/ecs/${local.application.name}"
}


