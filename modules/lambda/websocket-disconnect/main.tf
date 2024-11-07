resource "aws_lambda_function" "websocket_disconnect" {
  function_name = "websocket_disconnect"
  role          = aws_iam_role.websocket_disconnect_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  s3_bucket     = var.lambda_code.s3_bucket
  s3_key        = var.lambda_code.websocket_disconnect_s3key
  timeout       = 300

  tracing_config {
    mode = "Active"
  }
}