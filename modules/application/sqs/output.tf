output "cryptocurrency_withdrawal" {
  value = {
    arn = aws_sqs_queue.cryptocurrency_withdrawal.arn
    url = aws_sqs_queue.cryptocurrency_withdrawal.url
  }
}

output "cryptocurrency_sweeper" {
  value = {
    arn = aws_sqs_queue.cryptocurrency_sweeper.arn
    url = aws_sqs_queue.cryptocurrency_sweeper.url
  }
}

output "notification_dispatcher" {
  value = {
    arn = aws_sqs_queue.notification_dispatcher.arn
    url = aws_sqs_queue.notification_dispatcher.url
  }
}