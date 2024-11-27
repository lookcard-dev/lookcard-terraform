output "lambda_aggregator_tron_sg" {
  value = {
    id = aws_security_group.lambda_cryptocurrency_sweep_processor_sg.id
  }
}
