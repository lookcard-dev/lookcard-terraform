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

  success_retention_period = 31
  failure_retention_period = 31

  schedule {
    expression = "rate(1 minutes)"
  }

  run_config {
    timeout_in_seconds = 15
    active_tracing     = true
  }
  tags = {
    Name = "canary"
  }
  depends_on = [aws_iam_role_policy.cw_canary_policy]

}