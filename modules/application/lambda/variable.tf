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
    s3_bucket               = string
    websocket_connect_s3key = string
    elliptic_s3key          = string
  })
}


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
