output "sumsub_webhook" {
  value = {
    invoke_arn = aws_lambda_function.sumsub_webhook.invoke_arn
  }
}
