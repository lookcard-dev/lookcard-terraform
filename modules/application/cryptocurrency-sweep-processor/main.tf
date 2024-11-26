data "aws_ecr_image" "cryptocurrency_sweep_processor_data" {
  repository_name = "aggregator-tron"
  most_recent     = true
}

resource "aws_lambda_function" "cryptocurrency_sweep_processor_functions" {
  function_name = "Cryptocurrency_Sweep_Processor"
  role          = aws_iam_role.lambda_cryptocurrency_sweep_processor_roles.arn // Secret manager - Aggregator-env
  architectures = ["x86_64"]
  package_type  = "Image"
  image_uri     = data.aws_ecr_image.cryptocurrency_sweep_processor_data.image_uri #"${var.image.url}:${var.image.tag}"
  timeout       = 900
  memory_size   = 512

  tracing_config {
    mode = "Active"
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
  batch_size       = 10 # Change as per your requirements
}