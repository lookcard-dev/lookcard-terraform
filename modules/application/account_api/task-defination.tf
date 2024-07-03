data "aws_ecr_image" "latest" {
  repository_name = "account-api"
  most_recent     = true
}

resource "aws_ecs_task_definition" "Account_API" {
  family                   = "Account-API"
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
      name  = "Account-API"
      image = data.aws_ecr_image.latest.image_uri
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/Account-API",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      secrets = local.ecs_task_secret_vars
      environment = [
        {
          name  = "CRYPTO_API_URL"
          value = "https://api.test.lookcard.io"
        },
        {
          name  = "DATABASE_NAME"
          value = "main"
        },
        {
          name  = "SQS_NOTIFICATION_QUEUE_URL"
          value = var.lookcard_notification_sqs_url
        },
        {
          name  = "SQS_ACCOUNT_WITHDRAWAL_QUEUE_URL"
          value = var.crypto_fund_withdrawal_sqs_url
        }
      ]
      portMappings = [
        {
          name          = "look-card-account-api-8080-tcp",
          containerPort = 8080,
          hostPort      = 8080,
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
  name = "/ecs/Account-API"
}


