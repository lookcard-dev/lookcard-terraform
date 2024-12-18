resource "aws_lambda_function" "cryptocurrency_sweep_processor_functions" {
  function_name = local.lambda_function.name
  role          = aws_iam_role.lambda_cryptocurrency_sweep_processor_roles.arn // Secret manager - Aggregator-env
  architectures = local.lambda_function.architectures
  package_type  = local.lambda_function.package_type
  image_uri     = "${var.image.url}:${var.image.tag}"
  timeout       = local.lambda_function.timeout
  memory_size   = local.lambda_function.memory_size

  tracing_config {
    mode = local.lambda_function.tracing_mode
  }

  environment {
    variables = local.lambda_env_vars
  }

  vpc_config {
    subnet_ids         = var.network.private_subnet
    security_group_ids = [aws_security_group.lambda_cryptocurrency_sweep_processor_sg.id]
  }
}

resource "aws_lambda_event_source_mapping" "cryptocurrency_sweep_processor_queue_event" {
  depends_on       = [aws_lambda_function.cryptocurrency_sweep_processor_functions]
  event_source_arn = var.sqs.cryptocurrency_sweeper.arn
  function_name    = aws_lambda_function.cryptocurrency_sweep_processor_functions.function_name
  batch_size       = 10
}