resource "aws_lambda_function" "websocket" {
  depends_on    = [data.archive_file.lambda]
  function_name = "Websocket"
  role          = aws_iam_role.websocket_role.arn
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  architectures = ["x86_64"]
  s3_bucket     = "develop-lambda-aml-code-develop"
  s3_key        = "lookcard-websocket.zip"
  timeout       = 300
}

resource "aws_lambda_event_source_mapping" "websocket_web" {
  depends_on       = [aws_lambda_function.websocket]
#   event_source_arn = aws_sqs_queue.push_message_web.arn
  event_source_arn = var.sqs.push_message_web_arn
  function_name    = aws_lambda_function.websocket.function_name
  batch_size       = 10 # Change as per your requirements
}

# resource "aws_lambda_function" "push_message_web_function" {
#   depends_on    = [data.archive_file.lambda]
#   function_name = "Push_Message_web"
#   role          = aws_iam_role.push_web_role.arn
#   handler       = "index.handler"
#   runtime       = "nodejs20.x"
#   architectures = ["x86_64"]
#   s3_bucket     = "develop-lambda-aml-code-develop"
#   s3_key        = "lookcard-websocket.zip"
#   timeout       = 300
# }
