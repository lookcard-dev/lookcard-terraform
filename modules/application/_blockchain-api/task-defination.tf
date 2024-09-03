resource "aws_ecs_task_definition" "blockchain" {
  family                   = local.application.name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  task_role_arn            = var.iam_role
  execution_role_arn       = var.iam_role
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
      environment = local.ecs_task_secret_vars
      portMappings = [
        {
          name          = "look-card-blockchain-3000-tcp",
          containerPort = local.application.port,
          hostPort      = local.application.port,
          protocol      = "tcp",
          appProtocol   = "http",
        },
        # Add more port mappings as needed
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

resource "aws_cloudwatch_log_group" "blockchain" {
  name = "/ecs/${local.application.name}"
}