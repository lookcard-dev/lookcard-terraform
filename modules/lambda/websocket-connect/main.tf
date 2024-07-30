resource "aws_lambda_function" "websocket_connect" {
  function_name = "websocket_connect"
  role          = aws_iam_role.websocket_connect_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  s3_bucket     = var.lambda_code.s3_bucket
  s3_key        = var.lambda_code.websocket_connect_s3key
  timeout       = 300
}