
variable "secret_manager" {}

variable "lambda_code_s3_bucket" {}
variable "lambda_code_data_process_s3key" {}

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
