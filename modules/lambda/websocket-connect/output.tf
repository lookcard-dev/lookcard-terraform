output "websocket_connect_arn" {
  value = aws_lambda_function.websocket_connect.invoke_arn
}

output "websocket_connect_name" {
  value = aws_lambda_function.websocket_connect.function_name
}