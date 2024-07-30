output "websocket_disconnect_arn" {
  value = aws_lambda_function.websocket_disconnect.invoke_arn
}

output "websocket_disconnect_name" {
  value = aws_lambda_function.websocket_disconnect.function_name
}