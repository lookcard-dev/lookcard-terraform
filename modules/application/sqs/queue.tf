resource "aws_sqs_queue" "notification_dispatcher" {
  name                        = "Notification_API-Dispatcher.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  visibility_timeout_seconds  = 60
  message_retention_seconds   = 86400
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
}

resource "aws_sqs_queue" "cryptocurrency_sweeper" {
  name                        = "Crypto_Processor-Sweep_Processor.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  visibility_timeout_seconds  = 3600
  message_retention_seconds   = 604800
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
}

resource "aws_sqs_queue" "cryptocurrency_withdrawal" {
  name                        = "Crypto_Processor-Withdrawal_Processor.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  visibility_timeout_seconds  = 3600
  message_retention_seconds   = 604800
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
}

resource "aws_sqs_queue" "crypto_processor_broadcast_transaction" {
  name                        = "Crypto_Processor-Broadcast_Transaction.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  visibility_timeout_seconds  = 3600
  message_retention_seconds   = 604800
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
}