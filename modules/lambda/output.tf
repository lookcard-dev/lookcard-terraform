# output "push_message_web_function" {
#   value = aws_lambda_function.push_message_web_function.function_name

# }

# output "push_message_web_invoke" {
#   value = aws_lambda_function.push_message_web_function.invoke_arn

# }

# output "websocket_invoke" {
#   value = aws_lambda_function.websocket_id.invoke_arn

# }

# output "websocket_function" {
#   value = aws_lambda_function.websocket_id.function_name

# }

# output "websocket_disconnect_invoke" {
#   value = aws_lambda_function.websocket_Remove_id.invoke_arn

# }

# output "websocket_disconnect_function" {
#   value = aws_lambda_function.websocket_Remove_id.function_name

# }

# output "eliptic_sqs" {
#   value = aws_sqs_queue.Eliptic.arn

# }

# output "withdraw_sqs" {
#   value = aws_sqs_queue.withdrawl.arn

# }

output "withdrawal_sqs" {
  value = aws_sqs_queue.Withdrawal.arn
  
}

output "lookcard_notification_sqs_url" {
  value = aws_sqs_queue.Lookcard_Notification_Queue.url
}

output "crypto_fund_withdrawal_sqs_url" {
  value = aws_sqs_queue.Crypto_Fund_Withdrawal_Queue.url
}

output "push_message_web_invoke" {
  value = aws_lambda_function.push_message_web_function.invoke_arn
}

output "push_message_web_function" {
  value = aws_lambda_function.push_message_web_function.function_name
}

output "web_socket_function" {
  value = aws_lambda_function.web_socket_id.function_name
}

output "web_socket_invoke" {
  value = aws_lambda_function.web_socket_id.invoke_arn

}

output "web_socket_disconnect_invoke" {
  value = aws_lambda_function.websocket_disconnect.invoke_arn
}

output "web_socket_disconnect_function" {
  value = aws_lambda_function.websocket_disconnect.function_name
}

output "aggregator_tron_sqs_url" {
  value = aws_sqs_queue.Aggregator_Tron_Queue.url
}

output "aggregator_tron_sqs_arn" {
  value = aws_sqs_queue.Aggregator_Tron_Queue.arn
}