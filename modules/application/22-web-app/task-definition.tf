resource "random_uuid" "next_auth_secret" {}

locals {
  environment_variables = [
    {
      name  = "SERVICE_NAME"
      value = var.name
    },
    {
      name  = "PORT"
      value = "3000"
    },
    {
      name  = "HOSTNAME"
      value = "0.0.0.0"
    },
    {
      name  = "RUNTIME_ENVIRONMENT"
      value = var.runtime_environment
    },
    {
      name  = "CORS_ORIGINS"
      value = "*"
    },
    {
      name  = "AWS_XRAY_DAEMON_ENDPOINT"
      value = "xray.daemon.lookcard.local:2337"
    },
    {
      name  = "AWS_CLOUDWATCH_LOG_GROUP_NAME"
      value = aws_cloudwatch_log_group.app_log_group.name
    },
    {
      name  = "NEXTAUTH_URL"
      value = "https://app.${var.domain.general.name}"
    },
    # Internal API URLs for microservices communication
    {
      name  = "ACCOUNT_API_URL"
      value = "http://account.api.lookcard.local:8080"
    },
    {
      name  = "USER_API_URL"
      value = "http://user.api.lookcard.local:8080"
    },
    {
      name  = "CARD_API_URL"
      value = "http://card.api.lookcard.local:8080"
    },
    {
      name  = "CRYPTO_API_URL"
      value = "http://crypto.api.lookcard.local:8080"
    },
    {
      name  = "PROFILE_API_URL"
      value = "http://profile.api.lookcard.local:8080"
    },
    {
      name  = "VERIFICATION_API_URL"
      value = "http://verification.api.lookcard.local:8080"
    },
    {
      name  = "NOTIFICATION_API_URL"
      value = "http://notification.api.lookcard.local:8080"
    },
    {
      name  = "DATA_API_URL"
      value = "http://data.api.lookcard.local:8080"
    },
    {
      name  = "CONFIG_API_URL"
      value = "http://config.api.lookcard.local:8080"
    },
    {
      name  = "REAP_API_URL"
      value = "http://reap.proxy.lookcard.local:8080"
    },
    {
      name  = "REFERRAL_API_URL"
      value = "http://referral.api.lookcard.local:8080"
    },
    {
      name  = "FUSIONAUTH_URL"
      value = "http://fusionauth.lookcard.local:9011"
    },
    {
      name  = "NEXTAUTH_SECRET"
      value = random_uuid.next_auth_secret.result
    },
    {
      name  = "NEXT_PUBLIC_ENABLE_REWARD_COMPONENT"
      value = var.runtime_environment == "production" ? "false" : "true"
    },
    {
      name  = "NEXT_PUBLIC_ENABLE_ONRAMP_PROVIDERS"
      value = var.runtime_environment == "production" ? "false" : "true"
    },
    {
      name  = "NEXT_PUBLIC_ENABLE_ALCHEMY_PAY"
      value = var.runtime_environment == "production" ? "false" : "true"
    },
    {
      name  = "NEXT_PUBLIC_ALCHEMY_PAY_ENVIRONMENT"
      value = var.runtime_environment == "production" ? "prod" : "test"
    },
    {
      name  = "ALCHEMY_PAY_ENVIRONMENT"
      value = var.runtime_environment == "production" ? "prod" : "test"
    },
    {
      name  = "SSE_WEBHOOK_SECRET",
      value = "R7NcCezdxDMtr#Sy"
    }
  ]

  environment_secrets = [
    {
      name      = "FUSIONAUTH_APPLICATION_ID"
      valueFrom = "${var.secret_arns["FUSIONAUTH"]}:APPLICATION_ID::"
    },
    {
      name      = "FUSIONAUTH_TENANT_ID"
      valueFrom = "${var.secret_arns["FUSIONAUTH"]}:TENANT_ID::"
    },
    {
      name      = "FUSIONAUTH_API_KEY"
      valueFrom = "${var.secret_arns["FUSIONAUTH"]}:API_KEY::"
    },
    {
      name      = "NEXT_PUBLIC_ALCHEMY_PAY_APP_ID"
      valueFrom = "${var.secret_arns["ALCHEMY_PAY"]}:APP_ID::"
    },
    {
      name      = "ALCHEMY_PAY_APP_ID"
      valueFrom = "${var.secret_arns["ALCHEMY_PAY"]}:APP_ID::"
    },
    {
      name      = "ALCHEMY_PAY_SECRET_KEY"
      valueFrom = "${var.secret_arns["ALCHEMY_PAY"]}:SECRET_KEY::"
    },
    {
      name      = "ALCHEMY_PAY_API_URL"
      valueFrom = "${var.secret_arns["ALCHEMY_PAY"]}:API_URL::"
    },
    {
      name      = "ALCHEMY_PAY_BASE_URL"
      valueFrom = "${var.secret_arns["ALCHEMY_PAY"]}:BASE_URL::"
    }
  ]
}

resource "aws_cloudwatch_log_group" "app_log_group" {
  name              = "/ecs/${var.name}"
  retention_in_days = var.runtime_environment == "production" ? 30 : 7

  tags = {
    Name        = "${var.name}-log-group"
    Environment = var.runtime_environment
  }
}

resource "aws_ecs_task_definition" "task_definition" {
  family             = var.name
  network_mode       = "awsvpc"
  cpu                = var.runtime_environment == "production" ? "2048" : "512"
  memory             = var.runtime_environment == "production" ? "4096" : "1024"
  task_role_arn      = aws_iam_role.task_role.arn
  execution_role_arn = aws_iam_role.task_execution_role.arn


  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name      = var.name
      essential = true
      image     = "${var.repository_urls[var.name]}:${var.image_tag}"

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-create-group"  = "true"
          "awslogs-group"         = "/ecs/${var.name}"
          "awslogs-region"        = var.aws_provider.region
          "awslogs-stream-prefix" = "ecs"
        }
      }

      environment = local.environment_variables
      secrets     = local.environment_secrets

      portMappings = [
        {
          name          = "3000-tcp"
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]

      readonlyRootFilesystem = false # Next.js needs write access for .next cache

      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:3000/api/health || exit 1"]
        interval    = 30 # seconds between health checks
        timeout     = 10 # health check timeout in seconds (higher for SSR)
        retries     = 3  # number of retries before marking container unhealthy
        startPeriod = 60 # time to wait before performing first health check (Next.js startup)
      }
    }
  ])

  tags = {
    Name        = var.name
    Environment = var.runtime_environment
  }
}
