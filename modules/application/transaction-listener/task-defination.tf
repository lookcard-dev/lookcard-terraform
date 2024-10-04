resource "aws_ecs_task_definition" "transaction_listener" {
  family       = local.nile-trongrid.name
  network_mode = "bridge"
  # requires_compatibilities = ["FARGATE"]
  cpu                = "256"
  memory             = "512"
  task_role_arn      = aws_iam_role.transaction_listener_task_role.arn
  execution_role_arn = aws_iam_role.transaction_listener_task_exec_role.arn

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
      environment = [
        # {
        #   name  = "NODE_ID"
        #   value = "tron-nile-alpha" // confirm
        # },
        # {
        #   name  = "NODE_ECO"
        #   value = "TRON" // confirm
        # },
        # {
        #   name  = "NODE_BLOCKCHAIN_ID"
        #   value = "tron-nile" // confirm
        # },
        # {
        #   name  = "CRYPTO_API_PROTOCOL"
        #   value = "http"
        # },
        # {
        #   name  = "CRYPTO_API_HOST"
        #   value = "crypto.api.lookcard.local"
        # },
        # {
        #   name  = "CRYPTO_API_PORT"
        #   value = "8080"
        # },
        # {
        #   name  = "DYNAMODB_BLOCK_RECORD_TABLE_NAME"
        #   value = "Crypto_Transaction_Listener-Block_Record" // confirm
        # },
        # {
        #   name  = "INCOMING_TRANSACTION_QUEUE_URL"
        #   value = var.sqs.aggregator_tron_url
        # },
        # New listener env var
        {
          name  = "RUNTIME_ENVIRONMENT"
          value = var.env_tag
        },
        {
          name  = "AWS_XRAY_DAEMON_ENDPOINT"
          value = "xray.daemon.lookcard.local:2337"
        },
        {
          name  = "AWS_CLOUDWATCH_LOG_GROUP_NAME"
          value = "/lookcard/crypto-listener/tron/nile/trongrid"
        },
        {
          name  = "DATABASE_HOST"
          value = var.rds_aurora_postgresql_writer_endpoint
        },
        {
          name  = "DATABASE_READ_HOST"
          value = var.rds_aurora_postgresql_reader_endpoint
        },
        {
          name  = "DATABASE_PORT"
          value = "5432"
        },
        {
          name  = "DATABASE_SCHEMA"
          value = "crypto_listener"
        },
        {
          name  = "DATABASE_USE_SSL"
          value = "true"
        },
        {
          name  = "NODE_ID"
          value = "tron-nile-trongrid"
        },
        {
          name  = "NODE_ECO"
          value = "TRON"
        },
        {
          name  = "NODE_BLOCKCHAIN_ID"
          value = "tron-nile"
        }
      ]
      secrets = [
        {
          name      = "DATABASE_NAME"
          valueFrom = "${var.database_secret_arn}:dbname::"
        },
        {
          name      = "DATABASE_USERNAME"
          valueFrom = "${var.database_secret_arn}:username::"
        },
        {
          name      = "DATABASE_PASSWORD"
          valueFrom = "${var.database_secret_arn}:password::"
        },
        {
          name      = "TRONGRID_API_KEY"
          valueFrom = "${var.trongrid_secret_arn}:API_KEY::"
        },
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${var.trongrid_secret_arn}:NILE_JSON_RPC_HTTP_ENDPOINT::"
        }
      ]
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

resource "aws_cloudwatch_log_group" "transaction_listener" {
  name = "/ecs/${local.nile-trongrid.name}"
}

resource "aws_cloudwatch_log_group" "crypto_listener_application_log" {
  name = "/lookcard/crypto-listener/tron/nile/trongrid"
}

resource "aws_ecs_task_definition" "tron_nile_listener_getblock" {
  family       = local.nile-getblock.name
  network_mode = "bridge"
  # requires_compatibilities = ["FARGATE"]
  cpu                = "256"
  memory             = "512"
  task_role_arn      = aws_iam_role.transaction_listener_task_role.arn
  execution_role_arn = aws_iam_role.transaction_listener_task_exec_role.arn

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
      environment = [
        {
          name  = "RUNTIME_ENVIRONMENT"
          value = var.env_tag
        },
        {
          name  = "AWS_XRAY_DAEMON_ENDPOINT"
          value = "xray.daemon.lookcard.local:2337"
        },
        {
          name  = "AWS_CLOUDWATCH_LOG_GROUP_NAME"
          value = "/lookcard/crypto-listener/tron/nile/trongrid"
        },
        {
          name  = "DATABASE_HOST"
          value = var.rds_aurora_postgresql_writer_endpoint
        },
        {
          name  = "DATABASE_READ_HOST"
          value = var.rds_aurora_postgresql_reader_endpoint
        },
        {
          name  = "DATABASE_PORT"
          value = "5432"
        },
        {
          name  = "DATABASE_SCHEMA"
          value = "crypto_listener"
        },
        {
          name  = "DATABASE_USE_SSL"
          value = "true"
        },
        {
          name  = "NODE_ID"
          value = "tron-nile-getblock"
        },
        {
          name  = "NODE_ECO"
          value = "TRON"
        },
        {
          name  = "NODE_BLOCKCHAIN_ID"
          value = "tron-nile"
        }
      ]
      secrets = [
        {
          name      = "DATABASE_NAME"
          valueFrom = "${var.database_secret_arn}:dbname::"
        },
        {
          name      = "DATABASE_USERNAME"
          valueFrom = "${var.database_secret_arn}:username::"
        },
        {
          name      = "DATABASE_PASSWORD"
          valueFrom = "${var.database_secret_arn}:password::"
        },
        {
          name      = "RPC_ENDPOINT"
          valueFrom = "${var.get_block_secret_arn}:TRON_NILE_JSON_RPC_HTTP_ENDPOINT::"
        }
      ]
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

resource "aws_cloudwatch_log_group" "nile_getblock" {
  name = "/ecs/${local.nile-getblock.name}"
}

resource "aws_cloudwatch_log_group" "nile_getblock_log_group" {
  name = "/lookcard/crypto-listener/tron/nile/getblock"
}