resource "aws_ecs_task_definition" "tron_nile_listener_trongrid" {
  family       = local.nile-trongrid.name
  network_mode = "bridge"
  cpu                = "256"
  memory             = "512"
  task_role_arn      = aws_iam_role.crypto_listener_trongrid_task_role.arn
  execution_role_arn = aws_iam_role.crypto_listener_trongrid_task_exec_role.arn

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }


  container_definitions = jsonencode([
    {
      name  = local.nile-trongrid.name
      image = "${local.nile-trongrid.image}:${local.nile-trongrid.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/${local.nile-trongrid.name}",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = local.ecs_task_env_vars_trongrid
      secrets = local.ecs_task_secret_vars_trongrid
      # portMappings = [
      #   {
      #     name          = "look-card-transaction-listener-8080-tcp",
      #     containerPort = local.nile-trongrid.port,
      #     hostPort      = local.nile-trongrid.port,
      #     protocol      = "tcp",
      #     appProtocol   = "http",
      #   },
      # ]
      readonlyRootFilesystem : true
    }
  ])
}

resource "aws_ecs_task_definition" "tron_nile_listener_getblock" {
  family       = local.nile-getblock.name
  network_mode = "bridge"
  cpu                = "256"
  memory             = "512"
  task_role_arn      = aws_iam_role.crypto_listener_getblock_task_role.arn
  execution_role_arn = aws_iam_role.crypto_listener_getblock_task_exec_role.arn

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }


  container_definitions = jsonencode([
    {
      name  = local.nile-getblock.name
      image = "${local.nile-getblock.image}:${local.nile-getblock.image_tag}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/${local.nile-getblock.name}",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      environment = local.ecs_task_env_vars_getblock
      secrets = local.ecs_task_secret_vars_getblock
      # portMappings = [
      #   {
      #     name          = "look-card-transaction-listener-8080-tcp",
      #     containerPort = local.nile-getblock.port,
      #     hostPort      = local.nile-getblock.port,
      #     protocol      = "tcp",
      #     appProtocol   = "http",
      #   },
      # ]
      readonlyRootFilesystem : true
    }
  ])
}
