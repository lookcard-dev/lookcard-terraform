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
  type = string
}

variable "kms_key_arns" {
  type = object({
    data = object({
      generator  = string
      encryption = string
    })
  })
}

variable "secret_arns" {
  type = map(string)
}

variable "external_security_group_ids" {
  type = object({
    bastion_host = string
  })
}

variable "s3_bucket_names" {
  type = object({
    data = string
  })
}

variable "repository_urls" {
  type = map(string)
}

locals {
  environment_variables = [
    {
      name  = "PORT"
      value = "8080"
    },
    {
      name  = "CORS_ORIGINS"
      value = "*"
    },
    {
      name  = "RUNTIME_ENVIRONMENT"
      value = var.runtime_environment
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
      name  = "AWS_DYNAMODB_DATA_TABLE_NAME"
      value = aws_dynamodb_table.data.name
    },
    {
      name  = "AWS_DYNAMODB_NONCE_TABLE_NAME"
      value = aws_dynamodb_table.nonce.name
    },
    {
      name  = "AWS_KMS_GENERATOR_KEY_ID"
      value = var.kms_key_arns.data.generator
    },
    {
      name  = "AWS_KMS_ENCRYPTION_KEY_ID"
      value = var.kms_key_arns.data.encryption
    },
    {
      name  = "AWS_KMS_GENERATOR_KEY_ARN"
      value = var.kms_key_arns.data.generator
    },
    {
      name  = "AWS_KMS_ENCRYPTION_KEY_ARN"
      value = var.kms_key_arns.data.encryption
    },
    {
      name  = "AWS_S3_DATA_BUCKET_NAME"
      value = var.s3_bucket_names.data
    }
  ]
  environment_secrets = [
    {
      name      = "SENTRY_DSN"
      valueFrom = "${var.secret_arns["SENTRY"]}:${upper(replace(var.name, "-", "_"))}_DSN::"
    },
  ]
}

