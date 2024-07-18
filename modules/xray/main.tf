data "archive_file" "canary_lambda" {
  type        = "zip"
  source_dir  = "${path.module}/opt"
  output_path = "${path.module}/tmp/123.zip"
}
# Canary
resource "aws_synthetics_canary" "canary" {
  name                 = "lookcard-tron"
  artifact_s3_location = "s3://${var.s3_bucket}/canary/ap-southeast-1/lookcard-tron/"
  execution_role_arn   = aws_iam_role.cw_canary_role.arn
  runtime_version      = "syn-nodejs-puppeteer-8.0"
  handler              = "apiCanaryBlueprint.handler"
  start_canary         = true
  zip_file             = data.archive_file.canary_lambda.output_path

  success_retention_period = 2
  failure_retention_period = 14

  schedule {
    expression = "rate(5 minutes)"
  }

  run_config {
    timeout_in_seconds = 15
    active_tracing     = false
  }

  tags = {
    Name = "canary"
  }
  depends_on = [aws_iam_role_policy.cw_canary_policy]

}


# resource "aws_synthetics_canary" "canary" {
#   name              = "lookcard-tron"
#   artifact_s3_location = "s3://${var.s3_bucket}/canary/ap-southeast-1/lookcard-tron/"
#   execution_role_arn   = aws_iam_role.cw_canary_role.arn
#   runtime_version      = "syn-nodejs-puppeteer-8.0"
#   schedule {
#     expression = "rate(5 minutes)"
#     duration_in_seconds = 0
#   }

#   run_config {
#     timeout_in_seconds = 60
#   }

#   s3_bucket {
#     name = var.s3_bucket
#   }

#   code {
#     handler  = "exports.handler"
#     script   = file("${path.module}/canary_script.js")
#   }

#   start_canary = true

#   depends_on = [aws_iam_role_policy.cw_canary_policy]
# }
