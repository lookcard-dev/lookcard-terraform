data "aws_ecr_image" "latest" {
  repository_name = "transaction-api"
  most_recent     = true

}
resource "aws_ecs_task_definition" "Transaction" {
  family                   = "Transaction"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "2048"
  memory                   = "4096"
  task_role_arn            = var.iam_role
  execution_role_arn       = var.iam_role
#   task_role_arn            = aws_iam_role.lookcard_ecs_task_role.arn
#   execution_role_arn       = aws_iam_role.lookcard_ecs_task_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  volume {
    name = "data"
  }
  volume {
    name = "npm"
  }
  volume {
    name = "tmp"
  }

  container_definitions = jsonencode([
    {
      name  = "Transaction"
      image = data.aws_ecr_image.latest.image_uri
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/Transaction",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      portMappings = [
        {
          name          = "look-card-transaction-3000-tcp",
          containerPort = 3000,
          hostPort      = 3000,
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
        {
          sourceVolume = "npm"
          containerPath = "/home/appuser/.npm"
        },
        {
          sourceVolume = "tmp"
          containerPath = "/tmp"
        }
      ]
    }
  ])
}

resource "aws_cloudwatch_log_group" "Transaction" {
  name = "/ecs/Transaction"

}


resource "aws_security_group" "transactionApi" {
#   depends_on  = [var.vpc_id]
  name        = "lookcard-transaction-service-security-grp"
  description = "Security group for ECS services"
  vpc_id      = var.network.vpc

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lookcard-transaction-security-group"
  }
}
