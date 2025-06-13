resource "aws_ecs_task_definition" "task_definition" {
  family             = var.name
  network_mode       = "awsvpc"
  cpu                = "512"
  memory             = "1024"
  task_role_arn      = aws_iam_role.task_role.arn
  execution_role_arn = aws_iam_role.task_execution_role.arn
  runtime_platform {
    cpu_architecture        = "ARM64"
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name  = var.name
      image = "supabase/gotrue:v2.176.1"

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/${var.name}",
          "awslogs-region"        = var.aws_provider.region,
          "awslogs-stream-prefix" = "ecs",
        }
      }

      environment = [
        # Basic GoTrue Configuration
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

        # JWT Configuration
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

        # User Management
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

        # Email Configuration
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

        # API Configuration - Public Auth API
        {
          name  = "API_EXTERNAL_URL"
          value = "https://auth.${var.domain.general.name}"
        },
        {
          name  = "GOTRUE_API_EXTERNAL_URL"
          value = "https://auth.${var.domain.general.name}"
        },

        # Database
        {
          name  = "DB_NAMESPACE"
          value = "auth"
        },

        # Environment
        {
          name  = "RUNTIME_ENVIRONMENT"
          value = var.runtime_environment
        },

        # Rate Limiting
        {
          name  = "GOTRUE_RATE_LIMIT_EMAIL_SENT"
          value = "30"
        },

        # Password Requirements
        {
          name  = "GOTRUE_PASSWORD_MIN_LENGTH"
          value = "8"
        }
      ]

      secrets = [
        # Database Connection - GoTrue expects DATABASE_URL
        {
          name      = "DATABASE_URL"
          valueFrom = "${var.secret_arns["DATABASE"]}:supabase_database_url::"
        },

        # JWT Secret
        {
          name      = "GOTRUE_JWT_SECRET"
          valueFrom = "${var.secret_arns["SUPABASE"]}:jwt_secret::"
        },

        # Site Configuration
        {
          name      = "GOTRUE_SITE_URL"
          valueFrom = "${var.secret_arns["SUPABASE"]}:site_url::"
        },
        {
          name      = "GOTRUE_URI_ALLOW_LIST"
          valueFrom = "${var.secret_arns["SUPABASE"]}:uri_allow_list::"
        },

        # SMTP Configuration
        {
          name      = "GOTRUE_SMTP_HOST"
          valueFrom = "${var.secret_arns["SMTP"]}:host::"
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

        # Optional: Sentry for error tracking
        {
          name      = "SENTRY_DSN"
          valueFrom = "${var.secret_arns["SENTRY"]}:${upper(replace(var.name, "-", "_"))}_DSN::"
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

      # GoTrue doesn't require readonly root filesystem for auth operations
      readonlyRootFilesystem = false

      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:9999/health || exit 1"]
        interval    = 30 # seconds between health checks
        timeout     = 10 # health check timeout in seconds
        retries     = 3  # number of retries before marking container unhealthy
        startPeriod = 60 # time to wait before performing first health check
      }
    }
  ])
}

# Supabase Studio (Admin Dashboard) Task Definition
resource "aws_ecs_task_definition" "studio_task_definition" {
  family             = "${var.name}-studio"
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
      name  = "${var.name}-studio"
      image = "supabase/studio:20241029-46e1e40"

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/${var.name}-studio",
          "awslogs-region"        = var.aws_provider.region,
          "awslogs-stream-prefix" = "ecs",
        }
      }

      environment = [
        # Studio Configuration
        {
          name  = "STUDIO_PG_META_URL"
          value = "http://${var.name}-meta.${var.namespace_id}:8080"
        },
        {
          name  = "SUPABASE_AUTH_URL"
          value = "http://${var.name}.${var.namespace_id}:9999"
        },
        {
          name  = "SUPABASE_REST_URL"
          value = "http://${var.name}-rest.${var.namespace_id}:3000"
        },
        {
          name  = "SUPABASE_PUBLIC_URL"
          value = "https://supabase.${var.domain.admin.name}"
        },
        {
          name  = "SUPABASE_URL"
          value = "https://supabase.${var.domain.admin.name}"
        },
        {
          name  = "NEXT_PUBLIC_SUPABASE_URL"
          value = "https://supabase.${var.domain.admin.name}"
        }
      ]

      secrets = [
        # Database Connection - For Studio's database access
        {
          name      = "POSTGRES_HOST"
          valueFrom = "${var.secret_arns["DATABASE"]}:host::"
        },
        {
          name      = "POSTGRES_DB"
          valueFrom = "${var.secret_arns["DATABASE"]}:dbname::"
        },
        {
          name      = "POSTGRES_USER"
          valueFrom = "${var.secret_arns["DATABASE"]}:username::"
        },
        {
          name      = "POSTGRES_PASSWORD"
          valueFrom = "${var.secret_arns["DATABASE"]}:password::"
        },
        {
          name      = "POSTGRES_PORT"
          valueFrom = "${var.secret_arns["DATABASE"]}:port::"
        },

        # Supabase Configuration
        {
          name      = "SUPABASE_ANON_KEY"
          valueFrom = "${var.secret_arns["SUPABASE"]}:anon_key::"
        },
        {
          name      = "SUPABASE_SERVICE_KEY"
          valueFrom = "${var.secret_arns["SUPABASE"]}:service_role_key::"
        },
        {
          name      = "NEXT_PUBLIC_SUPABASE_ANON_KEY"
          valueFrom = "${var.secret_arns["SUPABASE"]}:anon_key::"
        }
      ]

      portMappings = [
        {
          name          = "studio-port",
          containerPort = 3000,
          hostPort      = 3000,
          protocol      = "tcp",
          appProtocol   = "http",
        },
      ]

      readonlyRootFilesystem = false

      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:3000 || exit 1"]
        interval    = 30
        timeout     = 10
        retries     = 3
        startPeriod = 60
      }
    }
  ])
}

# PostgREST (Auto-generated REST API) Task Definition
resource "aws_ecs_task_definition" "rest_task_definition" {
  family             = "${var.name}-rest"
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
      name  = "${var.name}-rest"
      image = "postgrest/postgrest:v12.2.3"

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/${var.name}-rest",
          "awslogs-region"        = var.aws_provider.region,
          "awslogs-stream-prefix" = "ecs",
        }
      }

      environment = [
        # PostgREST Configuration
        {
          name  = "PGRST_DB_SCHEMA"
          value = "public,auth"
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
          name  = "PGRST_APP_SETTINGS_JWT_AUD"
          value = "authenticated"
        },
        {
          name  = "PGRST_SERVER_HOST"
          value = "0.0.0.0"
        },
        {
          name  = "PGRST_SERVER_PORT"
          value = "3000"
        }
      ]

      secrets = [
        # Database Connection - PostgREST expects PGRST_DB_URI
        {
          name      = "PGRST_DB_URI"
          valueFrom = "${var.secret_arns["DATABASE"]}:supabase_database_url::"
        },

        # JWT Configuration
        {
          name      = "PGRST_JWT_SECRET"
          valueFrom = "${var.secret_arns["SUPABASE"]}:jwt_secret::"
        }
      ]

      portMappings = [
        {
          name          = "rest-port",
          containerPort = 3000,
          hostPort      = 3000,
          protocol      = "tcp",
          appProtocol   = "http",
        },
      ]

      readonlyRootFilesystem = true

      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:3000/ || exit 1"]
        interval    = 30
        timeout     = 10
        retries     = 3
        startPeriod = 60
      }
    }
  ])
}

# Postgres Meta (Database Management API) Task Definition
resource "aws_ecs_task_definition" "meta_task_definition" {
  family             = "${var.name}-meta"
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
      name  = "${var.name}-meta"
      image = "supabase/postgres-meta:v0.84.2"

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/${var.name}-meta",
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
        }
      ]

      secrets = [
        # Database Connection - Individual secrets for postgres-meta
        {
          name      = "PG_META_DB_HOST"
          valueFrom = "${var.secret_arns["DATABASE"]}:host::"
        },
        {
          name      = "PG_META_DB_NAME"
          valueFrom = "${var.secret_arns["DATABASE"]}:dbname::"
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

      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:8080/health || exit 1"]
        interval    = 30
        timeout     = 10
        retries     = 3
        startPeriod = 60
      }
    }
  ])
}
