resource "aws_sqs_queue" "notification_dispatcher" {
  name                        = "Notification_Dispatcher.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  visibility_timeout_seconds  = 60
  message_retention_seconds   = 86400
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
}

resource "aws_sqs_queue" "cryptocurrency_sweeper" {
  name                        = "Cryptocurrency_Sweeper.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  visibility_timeout_seconds  = 3600
  message_retention_seconds   = 604800
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
}

resource "aws_sqs_queue" "cryptocurrency_withdrawal" {
  name                        = "Crypto_Fund_Withdrawal.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  visibility_timeout_seconds  = 3600
  message_retention_seconds   = 604800
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
}
