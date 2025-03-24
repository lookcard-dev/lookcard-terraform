output "security_group_id" {
  value = aws_security_group.security_group.id
}

output "sweep_processor_queue_url" {
  value = aws_sqs_queue.sweep_processor.url
}

output "withdrawal_processor_queue_url" {
  value = aws_sqs_queue.withdrawal_processor.url
}

output "sweep_processor_queue_arn" {
  value = aws_sqs_queue.sweep_processor.arn
}

output "withdrawal_processor_queue_arn" {
  value = aws_sqs_queue.withdrawal_processor.arn
}