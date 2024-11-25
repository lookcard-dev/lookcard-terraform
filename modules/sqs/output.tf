# output "lookcard_notification_queue_url" {
#   value = aws_sqs_queue.lookcard_notification_queue.url
# }

# output "lookcard_notification_queue_arn" {
#   value = aws_sqs_queue.lookcard_notification_queue.arn
# }

# output "crypto_fund_withdrawal_queue_arn" {
#   value = aws_sqs_queue.crypto_fund_withdrawal_queue.arn
# }

# output "crypto_fund_withdrawal_queue_url" {
#   value = aws_sqs_queue.crypto_fund_withdrawal_queue.url
# }


output "push_message_web_arn" {
  value = aws_sqs_queue.push_message_web.arn
}

output "eliptic_arn" {
  value = aws_sqs_queue.eliptic.arn
}

# output "aggregator_tron_arn" {
#   value = aws_sqs_queue.aggregator_tron_queue.arn
# }

# output "aggregator_tron_url" {
#   value = aws_sqs_queue.aggregator_tron_queue.url
# }


