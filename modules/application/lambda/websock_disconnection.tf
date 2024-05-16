resource "aws_lambda_function" "web_socket_Remove_id" {
  function_name = "Web_Socket_ID_Remove"
  role          = var.web_scoket_disconnect_iam
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  s3_bucket     = "production-aml-code"
  s3_key        = "Web_Socket_ID_Remove-package.zip"
  timeout = 300
}

