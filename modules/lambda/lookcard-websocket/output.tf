output "lookcard_websocket_arn" {
  value = aws_lambda_function.websocket.invoke_arn
}

output "lookcard_websocket_name" {
  value = aws_lambda_function.websocket.function_name
}
