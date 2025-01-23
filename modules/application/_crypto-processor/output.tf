output "sweeper_processor_security_group_id" {
  value = aws_security_group.sweep_processor_security_group.id
}

output "sweeper_processor_queue_url" {
  value = aws_sqs_queue.sweep_processor_fifo_queue.url
}
