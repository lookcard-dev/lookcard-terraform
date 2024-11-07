data "aws_ecr_image" "lookcard-notification" {
  repository_name = "lookcard-notification"
  most_recent     = true
}

resource "aws_lambda_function" "lookcard_notification_function" {
  function_name = "Lookcard_Notification"
  role          = aws_iam_role.lookcard_notification_role.arn
  architectures = ["x86_64"]
  package_type  = "Image"
  image_uri     = data.aws_ecr_image.lookcard-notification.image_uri
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
    security_group_ids = [aws_security_group.lookcard_notification_sg.id]
  }
}

resource "aws_lambda_event_source_mapping" "lookcard_notification_queue_event" {
  depends_on       = [aws_lambda_function.lookcard_notification_function]
  event_source_arn = var.sqs.lookcard_notification_queue_arn
  function_name    = aws_lambda_function.lookcard_notification_function.function_name
  batch_size       = 10 # Change as per your requirements
}