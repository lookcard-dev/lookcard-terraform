resource "aws_ecs_task_definition" "reap_proxy" {
  family                   = local.application.name
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  task_role_arn            = aws_iam_role.reap_proxy_task_role.arn
  execution_role_arn       = aws_iam_role.reap_proxy_task_execution_role.arn
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
          "awslogs-group"         = "/ecs/${local.application.name}",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      secrets = local.ecs_task_secret_vars
      environment = local.ecs_task_env_vars
      portMappings = [
        {
          name          = "reap-proxy-8080-tcp",
          containerPort = local.application.port,
          hostPort      = local.application.port,
          protocol      = "tcp",
          appProtocol   = "http",
        },
      ]
    }
  ])
}
