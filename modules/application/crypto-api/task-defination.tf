resource "aws_ecs_task_definition" "crypto-api" {
  family                   = local.application.name
  network_mode             = "awsvpc"
  # requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  task_role_arn            = aws_iam_role.crypto_api_task_role.arn
  execution_role_arn       = aws_iam_role.crypto_api_task_execution_role.arn
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
          "awslogs-group"         = "lookcard/api/${local.application.name}",
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
          value = "arn:aws:kms:ap-southeast-1:227720554629:key/ce295816-2522-43cf-a880-4b8410c86fc2" // var.kms_data_generator_key_arn
        },
        {
          name  = "KMS_ENCRYPTION_KEY_ID_ALPHA"
          value = "arn:aws:kms:ap-southeast-1:227720554629:key/bd7162eb-db84-4a47-a87b-99e34c96d84e" //var.kms_data_encryption_key_alpha_arn
        },
        {
          name  = "AWS_CLOUDWATCH_LOG_GROUP_NAME"
          value = aws_cloudwatch_log_group.crypto_api.name
        },
        {
          name  = "AWS_CLOUDWATCH_LOG_STREAM_NAME"
          value = aws_cloudwatch_log_stream.crypto_api.name
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
resource "aws_cloudwatch_log_group" "crypto_api" {
  name = "lookcard/api/${local.application.name}"
}
resource "aws_cloudwatch_log_stream" "crypto_api" {
  name           = "${local.application.name}-log-stream"
  log_group_name = aws_cloudwatch_log_group.crypto_api.name
}