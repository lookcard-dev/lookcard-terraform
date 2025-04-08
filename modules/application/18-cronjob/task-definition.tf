resource "aws_ecs_task_definition" "batch_account_statement_generator_task_definition" {
  family             = "cronjob-batch_account_statement_generator"
  network_mode       = "awsvpc"
  cpu                = "2048"
  memory             = "4096"
  task_role_arn      = aws_iam_role.task_role.arn
  execution_role_arn = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name    = "generator"
      image   = "${var.repository_urls[var.name]}:${var.image_tag}"
      command = ["dumb-init", "node", "--import", "./src/utils/aws-xray-instrument.js", "--import", "./src/workflows/01-batch-account-statement-generator/index.js"]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/cronjob/batch_account_statement_generator",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      readonlyRootFilesystem = true
      environment = [
        {
          name  = "AWS_CLOUDWATCH_LOG_GROUP_NAME"
          value = "/lookcard/cronjob/batch_account_statement_generator"
        },
        {
          name  = "AWS_DYNAMODB_UNPROCESSED_ACCOUNT_STATEMENT_TABLE_NAME"
          value = aws_dynamodb_table.batch_account_statement_generator_unprocessed.name
        },
        {
          name  = "AWS_XRAY_DAEMON_ENDPOINT"
          value = "xray.daemon.lookcard.local:2337"
        }
      ]
      secrets = [{
        name      = "SENTRY_DSN"
        valueFrom = "${var.secret_arns["SENTRY"]}:CRONJOB_DSN::"
      }]
    },
    {
      name  = "account-api"
      image = "${var.repository_urls["account-api"]}:${var.api_image_tags.account_api}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/cronjob/account-api",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      readonlyRootFilesystem = true
      environment = concat(local.environment_variables, [
        {
          name  = "AWS_CLOUDWATCH_LOG_GROUP_NAME"
          value = "/lookcard/cronjob/account-api"
        },
        {
          name  = "DATABASE_SCHEMA"
          value = "account_api"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "SENTRY_DSN"
          valueFrom = "${var.secret_arns["SENTRY"]}:ACCOUNT_API_DSN::"
        },
      ])
      portMappings = [
        {
          name          = "8080-tcp",
          containerPort = 8080,
          hostPort      = 8080,
          protocol      = "tcp",
          appProtocol   = "http",
        },
      ]
      readonlyRootFilesystem = true
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:8080/healthcheckz || exit 1"]
        interval    = 30 # seconds between health checks
        timeout     = 5  # health check timeout in seconds
        retries     = 3  # number of retries before marking container unhealthy
        startPeriod = 10 # time to wait before performing first health check
      }
    }
  ])
}

resource "aws_ecs_task_definition" "batch_account_snapshot_processor_task_definition" {
  family             = "cronjob-batch_account_snapshot_processor"
  network_mode       = "awsvpc"
  cpu                = "1024"
  memory             = "2048"
  task_role_arn      = aws_iam_role.task_role.arn
  execution_role_arn = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name    = "processor"
      image   = "${var.repository_urls[var.name]}:${var.image_tag}"
      command = ["dumb-init", "node", "--import", "./src/utils/aws-xray-instrument.js", "--import", "./src/workflows/02-batch-account-snapshot-processor/index.js"]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/cronjob/batch_account_snapshot_processor",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      readonlyRootFilesystem = true
      environment = [
        {
          name  = "AWS_CLOUDWATCH_LOG_GROUP_NAME"
          value = "/lookcard/cronjob/batch_account_snapshot_processor"
        },
        {
          name  = "AWS_DYNAMODB_UNPROCESSED_ACCOUNT_SNAPSHOT_TABLE_NAME"
          value = aws_dynamodb_table.batch_account_snapshot_processor_unprocessed.name
        },
        {
          name  = "AWS_XRAY_DAEMON_ENDPOINT"
          value = "xray.daemon.lookcard.local:2337"
        }
      ]
      secrets = [{
        name      = "SENTRY_DSN"
        valueFrom = "${var.secret_arns["SENTRY"]}:CRONJOB_DSN::"
      }]
    },
    {
      name  = "account-api"
      image = "${var.repository_urls["account-api"]}:${var.api_image_tags.account_api}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/cronjob/account-api",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      readonlyRootFilesystem = true
      environment = concat(local.environment_variables, [
        {
          name  = "AWS_CLOUDWATCH_LOG_GROUP_NAME"
          value = "/lookcard/cronjob/account-api"
        },
        {
          name  = "DATABASE_SCHEMA"
          value = "account_api"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "SENTRY_DSN"
          valueFrom = "${var.secret_arns["SENTRY"]}:ACCOUNT_API_DSN::"
        },
      ])
      portMappings = [
        {
          name          = "8080-tcp",
          containerPort = 8080,
          hostPort      = 8080,
          protocol      = "tcp",
          appProtocol   = "http",
        },
      ]
      readonlyRootFilesystem = true
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:8080/healthcheckz || exit 1"]
        interval    = 30 # seconds between health checks
        timeout     = 5  # health check timeout in seconds
        retries     = 3  # number of retries before marking container unhealthy
        startPeriod = 10 # time to wait before performing first health check
      }
    }
  ])
}

resource "aws_ecs_task_definition" "batch_retry_wallet_deposit_processor_task_definition" {
  family             = "cronjob-batch_retry_wallet_deposit_processor"
  network_mode       = "awsvpc"
  cpu                = "512"
  memory             = "1024"
  task_role_arn      = aws_iam_role.task_role.arn
  execution_role_arn = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name    = "processor"
      essential = true
      image   = "${var.repository_urls[var.name]}:${var.image_tag}"
      command = ["dumb-init", "node", "--import", "./src/utils/aws-xray-instrument.js", "--import", "./src/workflows/03-batch-retry-failed-wallet-deposit-processor/index.js"]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/cronjob/batch_retry_wallet_deposit_processor",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      readonlyRootFilesystem = true
      environment = [
        {
          name  = "AWS_CLOUDWATCH_LOG_GROUP_NAME"
          value = "/lookcard/cronjob/batch_retry_wallet_deposit_processor"
        },
        {
          name  = "AWS_XRAY_DAEMON_ENDPOINT"
          value = "xray.daemon.lookcard.local:2337"
        }
      ]
      secrets = [{
        name      = "SENTRY_DSN"
        valueFrom = "${var.secret_arns["SENTRY"]}:CRONJOB_DSN::"
      }]
    },
    {
      name  = "crypto-api"
      image = "${var.repository_urls["crypto-api"]}:${var.api_image_tags.crypto_api}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/cronjob/crypto-api",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      readonlyRootFilesystem = true
      environment = concat(local.environment_variables, [
        {
          name  = "AWS_CLOUDWATCH_LOG_GROUP_NAME"
          value = "/lookcard/cronjob/crypto-api"
        },
        {
          name  = "DATABASE_SCHEMA"
          value = "crypto_api"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "SENTRY_DSN"
          valueFrom = "${var.secret_arns["SENTRY"]}:CRYPTO_API_DSN::"
        },
      ])
      portMappings = [
        {
          name          = "8080-tcp",
          containerPort = 8080,
          hostPort      = 8080,
          protocol      = "tcp",
          appProtocol   = "http",
        },
      ]
      readonlyRootFilesystem = true
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:8080/healthcheckz || exit 1"]
        interval    = 30 # seconds between health checks  
        timeout     = 5  # health check timeout in seconds
        retries     = 3  # number of retries before marking container unhealthy
        startPeriod = 10 # time to wait before performing first health check
      }
    }
  ])
}

resource "aws_ecs_task_definition" "batch_retry_wallet_withdrawal_processor_task_definition" {
  family             = "cronjob-batch_retry_wallet_withdrawal_processor"
  network_mode       = "awsvpc"
  cpu                = "512"
  memory             = "1024"
  task_role_arn      = aws_iam_role.task_role.arn
  execution_role_arn = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      name    = "processor"
      essential = true
      image   = "${var.repository_urls[var.name]}:${var.image_tag}"
      command = ["dumb-init", "node", "--import", "./src/utils/aws-xray-instrument.js", "--import", "./src/workflows/04-batch-retry-failed-wallet-withdrawal-processor/index.js"]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/cronjob/batch_retry_wallet_withdrawal_processor",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
          }
      }
      readonlyRootFilesystem = true
      environment = [
        {
          name  = "AWS_CLOUDWATCH_LOG_GROUP_NAME"
          value = "/lookcard/cronjob/batch_retry_wallet_withdrawal_processor"
        },
        {
          name  = "AWS_XRAY_DAEMON_ENDPOINT"
          value = "xray.daemon.lookcard.local:2337"
        }
      ]
      secrets = [{
        name      = "SENTRY_DSN"
        valueFrom = "${var.secret_arns["SENTRY"]}:CRONJOB_DSN::"
      }]
    },
    {
      name  = "crypto-api"
      essential = true
      image = "${var.repository_urls["crypto-api"]}:${var.api_image_tags.crypto_api}"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/cronjob/crypto-api",
          "awslogs-region"        = "ap-southeast-1",
          "awslogs-stream-prefix" = "ecs",
        }
      }
      readonlyRootFilesystem = true
      environment = concat(local.environment_variables, [
        {
          name  = "AWS_CLOUDWATCH_LOG_GROUP_NAME"
          value = "/lookcard/cronjob/crypto-api"
        },
        {
          name  = "DATABASE_SCHEMA"
          value = "crypto_api"
        }
      ])
      secrets = concat(local.environment_secrets, [
        {
          name      = "SENTRY_DSN"
          valueFrom = "${var.secret_arns["SENTRY"]}:CRYPTO_API_DSN::"
        },
      ])
      portMappings = [
        {
          name          = "8080-tcp",
          containerPort = 8080,
          hostPort      = 8080,
          protocol      = "tcp",
          appProtocol   = "http",
        },
      ]
      readonlyRootFilesystem = true
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:8080/healthcheckz || exit 1"]
        interval    = 30 # seconds between health checks
        timeout     = 5  # health check timeout in seconds
        retries     = 3  # number of retries before marking container unhealthy
        startPeriod = 10 # time to wait before performing first health check
      }
    }
  ])
}
