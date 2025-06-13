variable "aws_provider" {
  type = object({
    region     = string
    account_id = string
  })
}

variable "runtime_environment" {
  type = string
  validation {
    condition     = contains(["develop", "testing", "staging", "production", "sandbox"], var.runtime_environment)
    error_message = "runtime_environment must be one of: develop, testing, staging, production, or sandbox"
  }
}

variable "name" {
  type = string
}

variable "cluster_id" {
  type = string
}

variable "namespace_id" {
  type = string
}

variable "network" {
  type = object({
    vpc_id              = string
    private_subnet_ids  = list(string)
    public_subnet_ids   = list(string)
    isolated_subnet_ids = list(string)
  })
}

variable "allow_to_security_group_ids" {
  type = list(string)
}

variable "image_tag" {
  type        = string
  description = "Image tag for custom applications (not used for Supabase services)"
}

variable "domain" {
  type = object({
    general = object({
      name    = string
      zone_id = string
    })
    admin = object({
      name    = string
      zone_id = string
    })
  })
}

variable "secret_arns" {
  type        = map(string)
  description = "Map of secret ARNs for DATABASE, SUPABASE, SMTP, and SENTRY configurations"
}

variable "external_security_group_ids" {
  type = object({
    bastion_host = string
  })
}

variable "repository_urls" {
  type        = map(string)
  description = "Repository URLs for custom applications (not used for Supabase services)"
}

locals {
  environment_variables = [
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
    {
      name  = "GOTRUE_SECURITY_REFRESH_TOKEN_ROTATION_ENABLED"
      value = "true"
    },
    {
      name  = "GOTRUE_SECURITY_REFRESH_TOKEN_REUSE_INTERVAL"
      value = "10"
    },
    {
      name  = "API_EXTERNAL_URL"
      value = "https://${var.name}.${var.runtime_environment}.lookcard.com"
    },
    {
      name  = "DB_NAMESPACE"
      value = "auth"
    }
  ]

  environment_secrets = [
    {
      name      = "DATABASE_URL"
      valueFrom = "${var.secret_arns["DATABASE"]}:supabase_auth_database_url::"
    },
    {
      name      = "GOTRUE_JWT_SECRET"
      valueFrom = "${var.secret_arns["SUPABASE"]}:jwt_secret::"
    },
    {
      name      = "GOTRUE_SITE_URL"
      valueFrom = "${var.secret_arns["SUPABASE"]}:site_url::"
    },
    {
      name      = "GOTRUE_URI_ALLOW_LIST"
      valueFrom = "${var.secret_arns["SUPABASE"]}:uri_allow_list::"
    },
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
    {
      name      = "SENTRY_DSN"
      valueFrom = "${var.secret_arns["SENTRY"]}:${upper(replace(var.name, "-", "_"))}_DSN::"
    },
  ]
}

