resource "aws_ecs_task_definition" "task_definition" {
  family                   = var.name
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  task_role_arn            = aws_iam_role.task_role.arn
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name  = var.name
      image = "amazon/aws-xray-daemon"
      entryPoint = ["/xray", "-t", "0.0.0.0:2337", "-b", "0.0.0.0:2337"]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/${var.name}",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      portMappings = [
        {
          name          = "2337-udp",
          containerPort = 2337
          hostPort      = 2337
          protocol      = "udp",
        },
      ]
    }
  ])
}
