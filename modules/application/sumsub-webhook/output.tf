output "sumsub_webhook" {
  value = {
    invoke_arn = aws_lambda_function.sumsub_webhook.invoke_arn
  }
}

output "sumsub_webhook_lambda_func_sg" {
  value = {
    id = aws_security_group.sumsub_webhook_lambda_func_sg.id
  }
}