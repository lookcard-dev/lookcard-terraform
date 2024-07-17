resource "aws_ecs_task_definition" "crypto-api" {
  family                   = local.application.name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  task_role_arn            = aws_iam_role.crypto_api_task_role.arn
  execution_role_arn       = aws_iam_role.crypto_api_task_execution_role.arn
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
          name  = "AWS_REGION"
          value = "ap-southeast-1"
        },
        {
          name  = "DATABASE_NAME"
          value = "main"
        },
        {
          name  = "KMS_GENERATOR_KEY_ID"
          value = var.crypto_api_encryption_kms_arn
        },
        {
          name  = "KMS_ENCRYPTION_KEY_ID_ALPHA"
          value = var.crypto_api_generator_kms_arn
        },
      ]

      portMappings = [
        {
          name          = "look-card-crypto-api-8080-tcp",
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
resource "aws_cloudwatch_log_group" "crypto_api" {
  name = "/ecs/${local.application.name}"
}
