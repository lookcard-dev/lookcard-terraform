resource "aws_sqs_queue" "withdrawal" {
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

resource "aws_sqs_queue" "eliptic" {
  name                       = "Eliptic"
  receive_wait_time_seconds  = 0
  delay_seconds              = 0
  message_retention_seconds  = 345600
  max_message_size           = 2048
  visibility_timeout_seconds = 300
  tags = {
    Name = "Elliptic"
  }
}

resource "aws_sqs_queue" "aggregator_tron_queue" {
  name                        = "Aggregator_Tron.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  visibility_timeout_seconds  = 900
  delay_seconds               = 120 
}

resource "aws_sqs_queue" "notification" {
  name                       = "Notification"
  receive_wait_time_seconds  = 0
  delay_seconds              = 0
  message_retention_seconds  = 345600
  max_message_size           = 2048
  visibility_timeout_seconds = 360
  tags = {
    Name = "Notification"
  }
}


resource "aws_sqs_queue" "push_message_web" {
  name                       = "Push_Message_Web"
  receive_wait_time_seconds  = 0
  delay_seconds              = 0
  message_retention_seconds  = 345600
  max_message_size           = 2048
  visibility_timeout_seconds = 360
}

resource "aws_sqs_queue" "lookcard_notification_queue" {
  name                        = "Lookcard_Notification.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  visibility_timeout_seconds  = 1000
}

resource "aws_sqs_queue" "crypto_fund_withdrawal_queue" {
  name                        = "Crypto_Fund_Withdrawal.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  visibility_timeout_seconds  = 1000
}

# resource "aws_lambda_event_source_mapping" "Lookcard_Notification_Queue_event" {
#   depends_on                 = [aws_lambda_function.lookcard_notification_function]
#   event_source_arn           = aws_sqs_queue.Lookcard_Notification_Queue.arn
#   function_name              = aws_lambda_function.lookcard_notification_function.function_name
#   batch_size                 = 10 # Change as per your requirements
# }

# resource "aws_lambda_event_source_mapping" "Crypto_Fund_Withdrawal_Queue_event" {
#   depends_on                 = [aws_lambda_function.crypto_fund_withdrawal_function]
#   event_source_arn           = aws_sqs_queue.Crypto_Fund_Withdrawal_Queue.arn
#   function_name              = aws_lambda_function.crypto_fund_withdrawal_function.function_name
#   batch_size                 = 10 # Change as per your requirements
# }

# resource "aws_lambda_event_source_mapping" "Push_Message_Web" {
#   depends_on       = [aws_lambda_function.push_message_web_function]
#   event_source_arn = aws_sqs_queue.push_message_web.arn
#   function_name    = aws_lambda_function.push_message_web_function.function_name
#   batch_size       = 10 # Change as per your requirements
# }

# resource "aws_lambda_event_source_mapping" "Eliptic" {
#   depends_on       = [aws_lambda_function.eliptic]
#   event_source_arn = aws_sqs_queue.Eliptic.arn
#   function_name    = aws_lambda_function.eliptic.arn
#   batch_size       = 10 # Change as per your requirements
# }

# resource "aws_lambda_event_source_mapping" "Aggregator_Tron_Queue_event" {
#   depends_on       = [aws_lambda_function.aggregator_tron_function]
#   event_source_arn = aws_sqs_queue.Aggregator_Tron_Queue.arn
#   function_name    = aws_lambda_function.aggregator_tron_function.function_name
#   batch_size       = 10 # Change as per your requirements
# }

