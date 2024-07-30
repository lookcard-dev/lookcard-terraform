data "aws_iam_policy_document" "websocket" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "archive_file" "lambda" {
  type             = "zip"
  source_dir       = "${path.module}/test"
  output_file_mode = "0666"
  output_path      = "${path.module}/tmp/lambda.zip"
}

variable "sqs" {}
variable "secret_manager" {}
variable "general_config" {}