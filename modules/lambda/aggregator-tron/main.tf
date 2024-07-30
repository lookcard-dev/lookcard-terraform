data "aws_ecr_image" "aggregator_tron_data" {
  repository_name = "aggregator-tron"
  most_recent     = true
}

resource "aws_lambda_function" "aggregator_tron_functions" {
  function_name = "Aggregators_Tron"
  role          = aws_iam_role.lambda_aggregator_tron_roles.arn // Secret manager - Aggregator-env
  architectures = ["x86_64"]
  package_type  = "Image"
  image_uri     = data.aws_ecr_image.aggregator_tron_data.image_uri
  timeout       = 900
  memory_size   = 512

  environment {
    variables = local.lambda_env_vars
  }

  vpc_config {
    subnet_ids         = var.network.private_subnet
    security_group_ids = [aws_security_group.lambda_aggregator_tron_sg.id]
  }
}

resource "aws_lambda_event_source_mapping" "aggregator_tron_queue_event" {
  depends_on       = [aws_lambda_function.aggregator_tron_functions]
  event_source_arn = var.sqs.aggregator_tron_arn
  function_name    = aws_lambda_function.aggregator_tron_functions.function_name
  batch_size       = 10 # Change as per your requirements
}