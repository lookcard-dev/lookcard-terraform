resource "aws_sqs_queue" "sweep_processor" {
  name                        = "Crypto_Processor-Sweep_Processor.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  visibility_timeout_seconds  = 3600
  message_retention_seconds   = 604800
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
}

resource "aws_sqs_queue" "withdrawal_processor" {
  name                        = "Crypto_Processor-Withdrawal_Processor.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
  visibility_timeout_seconds  = 3600
  message_retention_seconds   = 604800
  deduplication_scope         = "messageGroup"
  fifo_throughput_limit       = "perMessageGroupId"
}