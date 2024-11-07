resource "aws_lambda_function" "data_process" {
  function_name = "data_process"
  role          = aws_iam_role.data_process_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  s3_bucket     = var.lambda_code.s3_bucket
  s3_key        = var.lambda_code.data_process_s3key
  timeout       = 300

  tracing_config {
    mode = "Active"
  }
}

