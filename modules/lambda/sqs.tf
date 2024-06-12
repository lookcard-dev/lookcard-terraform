resource "aws_sqs_queue" "Withdrawal" {
  name                       = "Withdrawal"
  receive_wait_time_seconds  = 0
  delay_seconds              = 0
  message_retention_seconds  = 345600
  max_message_size           = 2048
  visibility_timeout_seconds = 300
  tags = {
    Name = "Withdrawal"
  }
}

resource "aws_sqs_queue" "Lookcard_Notification_Queue" {
  name                        = "Lookcard_Notification.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  visibility_timeout_seconds  = 1000
}

resource "aws_sqs_queue" "Crypto_Fund_Withdrawal_Queue" {
  name                        = "Crypto_Fund_Withdrawal.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  visibility_timeout_seconds  = 1000
}

resource "aws_lambda_event_source_mapping" "Lookcard_Notification_Queue_event" {
  depends_on                 = [aws_lambda_function.lookcard_notification_function]
  event_source_arn           = aws_sqs_queue.Lookcard_Notification_Queue.arn
  function_name              = aws_lambda_function.lookcard_notification_function.function_name
  batch_size                 = 10 # Change as per your requirements
}

resource "aws_lambda_event_source_mapping" "Crypto_Fund_Withdrawal_Queue_event" {
  depends_on                 = [aws_lambda_function.crypto_fund_withdrawal_function]
  event_source_arn           = aws_sqs_queue.Crypto_Fund_Withdrawal_Queue.arn
  function_name              = aws_lambda_function.crypto_fund_withdrawal_function.function_name
  batch_size                 = 10 # Change as per your requirements
}

# resource "aws_sqs_queue" "Aggregator_Tron_Queue" {
#   name                        = "Aggregator_Tron.fifo"
#   fifo_queue                  = true
#   content_based_deduplication = true
#   visibility_timeout_seconds  = 360
#   delay_seconds               = 120 
# }

# resource "aws_lambda_event_source_mapping" "Aggregator_Tron_Queue_event" {
#   depends_on       = [aws_lambda_function.aggregator_tron_function]
#   event_source_arn = aws_sqs_queue.Aggregator_Tron_Queue.arn
#   function_name    = aws_lambda_function.aggregator_tron_function.function_name
#   batch_size       = 10 # Change as per your requirements
# }