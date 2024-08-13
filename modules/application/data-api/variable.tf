variable "default_listener" {}
variable "lookcardlocal_namespace" {}
variable "cluster" {}
variable "env_tag" {}
variable "secret_manager" {}
variable "s3_data_bucket_name" {}
variable "dynamodb_data_tb_name" {}

variable "kms" {}
variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}

variable "image" {
  type = object({
    url = string
    tag = string
  })
}

locals {
  application = {
    name      = "data-api"
    port      = 8080
    image     = var.image.url
    image_tag = var.image.tag
  }
  load_balancer = {
    data_api_path = ["/datas", "/datas/*"]
    data_priority = 401
  }
  ecs_task_secret_vars = [
    {
      name      = "SENTRY_DSN"
      valueFrom = "${var.secret_manager.sentry_secret_arn}:DATA_API_DSN::"
    }
  ]

  ecs_task_env_vars = [
    {
      name  = "AWS_KMS_GENERATOR_KEY_ID"
      value = var.kms.kms_data_generator_key_id
    },
    {
      name  = "AWS_KMS_ENCRYPTION_KEY_ID_ALPHA"
      value = var.kms.kms_data_encryption_key_id_alpha
    },
    {
      name  = "AWS_KMS_ENCRYPTION_KEY_ID_BETA"
      value = var.kms.kms_data_encryption_key_id_beta
    },
    {
      name  = "AWS_KMS_ENCRYPTION_KEY_ID_CHARLIE"
      value = var.kms.kms_data_encryption_key_id_charlie
    },
    {
      name  = "AWS_KMS_ENCRYPTION_KEY_ID_DELTA"
      value = var.kms.kms_data_encryption_key_id_delta
    },
    {
      name  = "AWS_KMS_ENCRYPTION_KEY_ID_ECHO"
      value = var.kms.kms_data_encryption_key_id_echo
    },
    {
      name  = "AWS_S3_DATA_BUCKET_NAME"
      value = var.s3_data_bucket_name
    },
    {
      name  = "AWS_DYNAMODB_DATA_TABLE_NAME"
      value = var.dynamodb_data_tb_name
    },
    {
      name  = "AWS_XRAY_DAEMON_ENDPOINT"
      value = "xray.daemon.lookcard.local:2337"
    },
    {
      name  = "RUNTIME_ENVIRONMENT"
      value = var.env_tag
    }
  ]

}
