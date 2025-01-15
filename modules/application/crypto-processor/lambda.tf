resource "aws_lambda_function" "sweep_processor" {
  function_name = "Crypto_Processor-Sweep_Processor"
  role          = aws_iam_role.sweep_processor_role.arn
  architectures = ["x86_64"]
  package_type  = "Image"
  image_uri     = "${var.image.url}:${var.image.tag}"
  image_config {
    command = ["workflows/sweep/index.handler"]
  }
  timeout     = 900
  memory_size = 512

  tracing_config {
    mode = "Active"
  }

  vpc_config {
    subnet_ids         = var.network.private_subnet
    security_group_ids = [aws_security_group.sweep_processor_security_group.id]
  }
}

resource "aws_lambda_event_source_mapping" "sweep_processor_queue_event" {
  depends_on       = [aws_lambda_function.sweep_processor]
  event_source_arn = aws_sqs_queue.sweep_processor_fifo_queue.arn
  function_name    = aws_lambda_function.sweep_processor.function_name
  batch_size       = 10 # Change as per your requirements
}
