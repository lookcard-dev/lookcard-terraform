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


variable "ddb_websocket_arn" {}
variable "lambda_code" {}
