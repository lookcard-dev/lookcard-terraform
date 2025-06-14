# GoTrue (Authentication Service) Task Definition
resource "aws_ecs_task_definition" "gotrue" {
  family             = "supabase-gotrue"
  network_mode       = "awsvpc"
  cpu                = "256"
  memory             = "512"
  task_role_arn      = aws_iam_role.task_role.arn
  execution_role_arn = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "ARM64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name  = "gotrue"
      image = "supabase/gotrue:v2.174.0"

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/supabase/gotrue",
          "awslogs-region"        = var.aws_provider.region,
          "awslogs-stream-prefix" = "ecs",
        }
      }
      // https://git.resel.fr/openresel/docker/supabase-auth/-/blob/master/example.env
      environment = [
        {
          name  = "PORT"
          value = "9999"
        },
        {
          name  = "GOTRUE_API_HOST"
          value = "0.0.0.0"
        },
        {
          name  = "GOTRUE_DB_DRIVER"
          value = "postgres"
        },
        {
          name  = "GOTRUE_LOG_LEVEL"
          value = var.runtime_environment == "production" ? "info" : "debug"
        },
        {
          name  = "GOTRUE_JWT_EXP"
          value = "3600"
        },
        {
          name  = "GOTRUE_JWT_AUD"
          value = "authenticated"
        },
        {
          name  = "GOTRUE_JWT_DEFAULT_GROUP_NAME"
          value = "authenticated"
        },
        {
          name  = "GOTRUE_DISABLE_SIGNUP"
          value = "false"
        },
        {
          name  = "GOTRUE_EXTERNAL_EMAIL_ENABLED"
          value = "true"
        },
        {
          name  = "GOTRUE_EXTERNAL_PHONE_ENABLED"
          value = "false"
        },
        {
          name  = "GOTRUE_MAILER_AUTOCONFIRM"
          value = var.runtime_environment == "develop" ? "true" : "false"
        },
        {
          name  = "GOTRUE_MAILER_SECURE_EMAIL_CHANGE_ENABLED"
          value = "true"
        },

        # Security
        {
          name  = "GOTRUE_SECURITY_REFRESH_TOKEN_ROTATION_ENABLED"
          value = "true"
        },
        {
          name  = "GOTRUE_SECURITY_REFRESH_TOKEN_REUSE_INTERVAL"
          value = "10"
        },
        {
          name  = "GOTRUE_SECURITY_UPDATE_PASSWORD_REQUIRE_REAUTHENTICATION"
          value = "true"
        },
        {
          name  = "API_EXTERNAL_URL"
          value = "https://supabase.${var.domain.general.name}"
        },
        {
          name  = "GOTRUE_API_EXTERNAL_URL"
          value = "https://supabase.${var.domain.general.name}"
        },
        {
          name  = "RUNTIME_ENVIRONMENT"
          value = var.runtime_environment
        },
        {
          name  = "GOTRUE_RATE_LIMIT_EMAIL_SENT"
          value = "30"
        },
        {
          name  = "GOTRUE_PASSWORD_MIN_LENGTH"
          value = "8"
        },
        {
          name  = "GOTRUE_SITE_URL"
          value = "https://app.${var.domain.general.name}"
        },
        {
          name  = "GOTRUE_URI_ALLOW_LIST"
          value = "https://app.${var.domain.general.name},https://admin.${var.domain.admin.name},http://localhost:3000"
        },
        {
          name  = "GOTRUE_SMTP_SENDER_NAME"
          value = "no-reply@${var.domain.general.name}"
        },
        {
          name  = "GOTRUE_SMS_PROVIDER",
          value = "twilio"
        }
      ]

      secrets = [
        {
          name      = "GOTRUE_DB_DATABASE_URL"
          valueFrom = "${var.secret_arns["SUPABASE"]}:database_url::"
        },
        {
          name      = "GOTRUE_JWT_SECRET"
          valueFrom = "${var.secret_arns["SUPABASE"]}:jwt_secret::"
        },
        {
          name      = "GOTRUE_SMTP_HOST"
          valueFrom = "${var.secret_arns["SMTP"]}:server::"
        },
        {
          name      = "GOTRUE_SMTP_PORT"
          valueFrom = "${var.secret_arns["SMTP"]}:port::"
        },
        {
          name      = "GOTRUE_SMTP_USER"
          valueFrom = "${var.secret_arns["SMTP"]}:username::"
        },
        {
          name      = "GOTRUE_SMTP_PASS"
          valueFrom = "${var.secret_arns["SMTP"]}:password::"
        },
        {
          name      = "GOTRUE_SMTP_ADMIN_EMAIL"
          valueFrom = "${var.secret_arns["SMTP"]}:admin_email::"
        },
        {
          name      = "GOTRUE_SMS_TWILIO_AUTH_TOKEN",
          valueFrom = "${var.secret_arns["TWILIO"]}:AUTH_TOKEN::"
        },
        {
          name      = "GOTRUE_SMS_TWILIO_ACCOUNT_SID",
          valueFrom = "${var.secret_arns["TWILIO"]}:ACCOUNT_SID::"
        },
        {
          name      = "GOTRUE_SMS_TWILIO_MESSAGE_SERVICE_SID",
          valueFrom = "${var.secret_arns["TWILIO"]}:MESSAGING_SERVICE_SID::"
        }
      ]

      portMappings = [
        {
          name          = "gotrue-port",
          containerPort = 9999,
          hostPort      = 9999,
          protocol      = "tcp",
          appProtocol   = "http",
        },
      ]

      readonlyRootFilesystem = false

      healthCheck = {
        command     = ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:9999/health"]
        interval    = 30
        timeout     = 10
        retries     = 3
        startPeriod = 60
      }
    }
  ])
}

resource "aws_ecs_task_definition" "postgrest" {
  family             = "supabase-postgrest"
  network_mode       = "awsvpc"
  cpu                = "256"
  memory             = "512"
  task_role_arn      = aws_iam_role.task_role.arn
  execution_role_arn = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "ARM64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name  = "postgrest"
      image = "postgrest/postgrest:v12.2.8"

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/supabase/postgrest",
          "awslogs-region"        = var.aws_provider.region,
          "awslogs-stream-prefix" = "ecs",
        }
      }

      environment = [
        {
          name  = "PGRST_SERVER_HOST"
          value = "0.0.0.0"
        },
        {
          name  = "PGRST_SERVER_PORT"
          value = "3000"
        },
        {
          name  = "PGRST_DB_SCHEMA"
          value = "public,storage,graphql_public"
        },
        {
          name  = "PGRST_DB_ANON_ROLE"
          value = "anon"
        },
        {
          name  = "PGRST_DB_USE_LEGACY_GUCS"
          value = "false"
        },
        {
          name  = "PGRST_APP_SETTINGS_JWT_SECRET"
          value = "super-secret-jwt-token-with-at-least-32-characters-long"
        },
        {
          name  = "PGRST_APP_SETTINGS_JWT_EXP"
          value = "3600"
        },
        {
          name  = "PGRST_LOG_LEVEL"
          value = var.runtime_environment == "production" ? "info" : "debug"
        }
      ]

      secrets = [
        {
          name      = "PGRST_DB_URI"
          valueFrom = "${var.secret_arns["SUPABASE"]}:database_url::"
        },
        {
          name      = "PGRST_JWT_SECRET"
          valueFrom = "${var.secret_arns["SUPABASE"]}:jwt_secret::"
        }
      ]

      portMappings = [
        {
          name          = "postgrest-port",
          containerPort = 3000,
          hostPort      = 3000,
          protocol      = "tcp",
          appProtocol   = "http",
        },
      ]

      readonlyRootFilesystem = false

      healthCheck = {
        command     = ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:3000/"]
        interval    = 30
        timeout     = 10
        retries     = 3
        startPeriod = 60
      }
    }
  ])
}

# Kong (API Gateway) Task Definition
resource "aws_ecs_task_definition" "kong" {
  family             = "supabase-kong"
  network_mode       = "awsvpc"
  cpu                = "256"
  memory             = "512"
  task_role_arn      = aws_iam_role.task_role.arn
  execution_role_arn = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "ARM64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name  = "kong"
      image = "kong:3.9.1-ubuntu"

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/supabase/kong",
          "awslogs-region"        = var.aws_provider.region,
          "awslogs-stream-prefix" = "ecs",
        }
      }

      environment = [
        # Kong Declarative Configuration Mode
        {
          name  = "KONG_DATABASE"
          value = "off"
        },
        {
          name  = "KONG_DECLARATIVE_CONFIG"
          value = "/etc/kong/kong.yml"
        },
        {
          name  = "KONG_PROXY_LISTEN"
          value = "0.0.0.0:8000"
        },
        {
          name  = "KONG_ADMIN_LISTEN"
          value = "0.0.0.0:8001"
        },
        {
          name  = "KONG_PROXY_ACCESS_LOG"
          value = "/dev/stdout"
        },
        {
          name  = "KONG_ADMIN_ACCESS_LOG"
          value = "/dev/stdout"
        },
        {
          name  = "KONG_PROXY_ERROR_LOG"
          value = "/dev/stderr"
        },
        {
          name  = "KONG_ADMIN_ERROR_LOG"
          value = "/dev/stderr"
        },
        {
          name  = "KONG_LOG_LEVEL"
          value = var.runtime_environment == "production" ? "notice" : "debug"
        },
        {
          name  = "KONG_PLUGINS"
          value = "bundled,cors,rate-limiting,request-transformer,response-transformer"
        },
        {
          name  = "KONG_PREFIX"
          value = "/usr/local/kong"
        },
        {
          name  = "KONG_NGINX_DAEMON"
          value = "off"
        },
        {
          name  = "KONG_DNS_ORDER",
          value = "LAST,A,CNAME"
        },
        {
          name  = "KONG_STATUS_LISTEN",
          value = "0.0.0.0:8100"
        }
      ]
      secrets = [
        {
          name      = "KONG_DECLARATIVE_CONFIG_STRING"
          valueFrom = aws_ssm_parameter.kong_config.arn
        }
      ]
      entryPoint = ["/bin/sh", "-c"]
      command = [
        <<-EOF
          set -e
          
          # Display Kong version and environment info
          echo "Starting Kong configuration setup..."
          echo "Kong version: $(kong version)"
          echo "Environment: ${var.runtime_environment}"
          
          # Create Kong configuration directory
          echo "Creating /etc/kong directory..."
          mkdir -p /etc/kong
          
          # Write Kong declarative configuration
          echo "Writing Kong configuration to /etc/kong/kong.yml..."
          echo "$KONG_DECLARATIVE_CONFIG_STRING" > /etc/kong/kong.yml
          
          # Display configuration info for debugging
          echo "Configuration file created. File info:"
          ls -la /etc/kong/
          echo "Configuration file contents (first 20 lines):"
          head -20 /etc/kong/kong.yml
          
          # Validate Kong configuration
          echo "Validating Kong configuration..."
          kong config parse /etc/kong/kong.yml
          
          # Start Kong in foreground mode
          echo "Starting Kong in foreground mode..."
          exec kong start --v
          EOF
      ]

      portMappings = [
        {
          name          = "kong-proxy-port",
          containerPort = 8000,
          hostPort      = 8000,
          protocol      = "tcp",
          appProtocol   = "http",
        },
        {
          name          = "kong-admin-port",
          containerPort = 8001,
          hostPort      = 8001,
          protocol      = "tcp",
          appProtocol   = "http",
          }, {
          name          = "kong-status-port",
          containerPort = 8100,
          hostPort      = 8100,
          protocol      = "tcp",
          appProtocol   = "http",
        },
      ]

      readonlyRootFilesystem = false

      healthCheck = {
        command     = ["CMD", "kong", "health"]
        interval    = 30
        timeout     = 10
        retries     = 3
        startPeriod = 60
      }
    }
  ])
}

resource "aws_ecs_task_definition" "postgres_meta" {
  family             = "supabase-postgres-meta"
  network_mode       = "awsvpc"
  cpu                = "256"
  memory             = "512"
  task_role_arn      = aws_iam_role.task_role.arn
  execution_role_arn = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "ARM64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name  = "postgres-meta"
      image = "supabase/postgres-meta:v0.84.2"

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/supabase/postgres-meta",
          "awslogs-region"        = var.aws_provider.region,
          "awslogs-stream-prefix" = "ecs",
        }
      }

      environment = [
        # Postgres Meta Configuration
        {
          name  = "PG_META_PORT"
          value = "8080"
        },
        {
          name  = "PG_META_DB_PORT"
          value = "5432"
        },
        {
          name  = "PG_META_DB_SSL"
          value = "prefer"
        },
        {
          name  = "PG_META_DB_NAME"
          value = "supabase"
        }
      ]
      secrets = [
        {
          name      = "PG_META_DB_HOST"
          valueFrom = "${var.secret_arns["DATABASE"]}:host::"
        },
        {
          name      = "PG_META_DB_USER"
          valueFrom = "${var.secret_arns["DATABASE"]}:username::"
        },
        {
          name      = "PG_META_DB_PASSWORD"
          valueFrom = "${var.secret_arns["DATABASE"]}:password::"
        }
      ]

      portMappings = [
        {
          name          = "meta-port",
          containerPort = 8080,
          hostPort      = 8080,
          protocol      = "tcp",
          appProtocol   = "http",
        },
      ]

      readonlyRootFilesystem = false
    }
  ])
}
