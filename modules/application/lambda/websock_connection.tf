resource "aws_lambda_function" "web_socket_id" {
  depends_on    = [data.archive_file.lambda]
  function_name = "web_socket_id"
  role          = var.web_scoket_iam
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  s3_bucket     = "production-aml-code"
  s3_key        = "web_socket_id-package.zip"
  #filename         = "${path.module}/tmp/lambda.zip"
  timeout = 300
  #source_code_hash = data.archive_file.lambda.output_base64sha256





}