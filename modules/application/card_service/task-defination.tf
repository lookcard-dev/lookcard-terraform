data "aws_ecr_image" "latest" {
  repository_name = "card-api"

  most_recent = true
}

resource "aws_ecs_task_definition" "Card" {
  family                   = "Card"
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
      name  = "Card"
      image = data.aws_ecr_image.latest.image_uri

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/Card",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      portMappings = [
        {
          name          = "look-card-8000-tcp",
          containerPort = 8000,
          hostPort      = 8000,
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

resource "aws_cloudwatch_log_group" "Card" {
  name = "/ecs/Card"
}