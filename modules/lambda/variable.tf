
variable "vpc_id" {}
variable "ddb_websocket_arn" {

}

variable "network" {
  type = object({
    vpc            = string
    private_subnet = list(string)
    public_subnet  = list(string)
  })
}

variable "lambda_code" {
  type = object({
    s3_bucket                  = string
    websocket_connect_s3key    = string
    websocket_disconnect_s3key = string
    data_process_s3key         = string
    elliptic_s3key             = string
    push_message_s3key         = string
    push_notification_s3key    = string
    withdrawal_s3key           = string
  })
}

variable "secret_manager" {}

data "aws_iam_policy_document" "lambda_sts_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

variable "dynamodb_table_arn" {}
