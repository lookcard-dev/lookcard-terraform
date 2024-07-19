resource "aws_ecs_task_definition" "config-api" {
  family                   = local.application.name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  task_role_arn            = aws_iam_role.config_api_task_role.arn
  execution_role_arn       = aws_iam_role.config_api_task_execution_role.arn
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
      # secrets = local.ecs_task_secret_vars
      environment = [
        {
          name  = "AWS_REGION"
          value = "ap-southeast-1"
        },
        {
          name  = "AWS_DYNAMODB_CONFIG_DATA_TABLE_NAME"
          value = var.dynamodb_config_api_config_data_name
        },{
          name  = "CORS_ORIGINS"
          value = "https://${var.lookcard_api_domain}"
        },{
          name  = "AWS_CLOUDWATCH_LOG_GROUP_NAME"
          value = aws_cloudwatch_log_group.config_api.name
        }
      ]

      portMappings = [
        {
          name          = "look-card-config-api-8080-tcp",
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
resource "aws_cloudwatch_log_group" "config_api" {
  name = "/ecs/${local.application.name}"
}
resource "aws_cloudwatch_log_stream" "config_api" {
  name = "config-api-log-stream"
  log_group_name = aws_cloudwatch_log_group.config_api.name
}
