variable "default_listener" {}
variable "api_lookcardlocal_namespace" {}
variable "cluster" {}
variable "kms_encryption_key_id_alpha_arn" {}
variable "kms_generator_key_id_arn" {}
variable "env_tag" {}
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
}
# ecs_task_secret_vars = [
#   {
#     name      = "SENTRY_DSN"
#     valueFrom = "${var.secret_manager.sentry_secret_arn}:DATA_API_DSN::"
#   },
# ]
# ecs_task_env_vars = [
#   {
#     name  = "AWS_KMS_GENERATOR_KEY_ID"
#     value = var.kms_generator_key_id_arn
#   },
#   {
#     name  = "AWS_KMS_ENCRYPTION_KEY_ID_ALPHA"
#     value = var.kms_encryption_key_id_alpha_arn
#   },
#   {
#     name  = "AWS_KMS_ENCRYPTION_KEY_ID_BETA"
#     value = var.kms_encryption_key_id_beta_arn
#   },
#   {
#     name  = "AWS_KMS_ENCRYPTION_KEY_ID_CHARLIE"
#     value = var.kms_encryption_key_id_charlie_arn
#   },
#   {
#     name  = "AWS_KMS_ENCRYPTION_KEY_ID_DELTA"
#     value = var.kms_encryption_key_id_delta_arn
#   },
#   {
#     name  = "AWS_KMS_ENCRYPTION_KEY_ID_ECO"
#     value = var.kms_encryption_key_id_eco_arn
#   },
#   {
#     name  = "AWS_S3_DATA_BUCKET_NAME"
#     value = var.s3_data_bucket_name
#   },
#   {
#     name  = "AWS_DYNAMODB_DATA_TABLE_NAME"
#     value = var.dyanmodb_data_tb_name
#   },
#   {
#     name  = "AWS_XRAY_DAEMON_ENDPOINT"
#     value = "xray.daemon.lookcard.local:2337"
#   },
#   {
#     name  = "RUNTIME_ENVIRONMENT"
#     value = var.env_tag
#   }
# ]
