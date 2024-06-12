data "aws_ecr_image" "latest" {
  repository_name = "authentication-api"
  most_recent     = true

}

resource "aws_ecs_task_definition" "Authentication" {
  family                   = "Authentication"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  # task_role_arn            = var.iam_role
  # execution_role_arn       = var.iam_role
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
      name  = "Authentication"
      image = data.aws_ecr_image.latest.image_uri

      environment_file = [""]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/Authentication",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      portMappings = [
        {
          name          = "look-card-authentication-8000-tcp",
          containerPort = 8000,
          hostPort      = 8000,
          protocol      = "tcp",
          appProtocol   = "http",

        },
        # Add more port mappings as needed

      ]
      mountPoints = [
        {
          sourceVolume  = "data",
          containerPath = "/usr/src/data",
        },

      ]
      readonlyRootFilesystem : true
    }
  ])
}

resource "aws_cloudwatch_log_group" "Card" {
  name = "/ecs/Authentication"
}

# Create Security Group for the Service
resource "aws_security_group" "Authentication" {
  depends_on  = [var.vpc_id]
  name        = "Authentication-Service-Security-Group"
  description = "Security group for ECS services"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    # security_groups = [aws_security_group.ALB_SG.id]
    security_groups = [var.sg_alb_id]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Authentication-Security-Group"
  }
}
