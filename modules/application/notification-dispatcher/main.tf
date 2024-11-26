data "aws_ecr_image" "notification_dispatcher" {
  repository_name = "lookcard-notification"
  most_recent     = true
}

resource "aws_lambda_function" "notification_dispatcher" {
  function_name = "Notification_Dispatcher"
  role          = aws_iam_role.notification_dispatcher.arn
  architectures = ["x86_64"]
  package_type  = "Image"
  image_uri     = data.aws_ecr_image.notification_dispatcher.image_uri #"${var.image.url}:${var.image.tag}"
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
    security_group_ids = [aws_security_group.notification_dispatcher.id]
  }
}

resource "aws_lambda_event_source_mapping" "notification_dispatcher_queue_event" {
  depends_on       = [aws_lambda_function.notification_dispatcher]
  event_source_arn = var.sqs.notification_dispatcher.arn
  function_name    = aws_lambda_function.notification_dispatcher.function_name
  batch_size       = 10 # Change as per your requirements
}