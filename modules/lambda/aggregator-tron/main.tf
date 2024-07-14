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
    variables = {
      "CRYPTO_API_PROTOCOL"             = "http"
      "CRYPTO_API_HOST"                 = "crypto.api.lookcard.local"
      "CRYPTO_API_PORT"                 = 8080
      "USER_API_PROTOCOL"               = "http"
      "USER_API_HOST"                   = "user.api.lookcard.local"
      "USER_API_PORT"                   = 8000
      "ACCOUNT_API_PROTOCOL"            = "http"
      "ACCOUNT_API_HOST"                = "account.api.lookcard.local"
      "ACCOUNT_API_PORT"                = 8080
      "SECRET_MANAGER_NAME"             = "Aggregator-env"
      "COINRANKING_SECRET_ARN"          = "arn:aws:secretsmanager:ap-southeast-1:975050173595:secret:COINRANKING-5Js8eX"
      "ELLIPTIC_SECRET_ARN"             = "arn:aws:secretsmanager:ap-southeast-1:975050173595:secret:ELLIPTIC-5fL1JA"
      "SYSTEM_CRYPTO_WALLET_SECRET_ARN" = "arn:aws:secretsmanager:ap-southeast-1:975050173595:secret:SYSTEM_CRYPTO_WALLET-biOCGt"
    #   "SQS_NOTIFICATION_QUEUE_URL"      = aws_sqs_queue.Lookcard_Notification_Queues.url
      "SQS_NOTIFICATION_QUEUE_URL"      = var.sqs.lookcard_notification_queue_url
    }
  }

  vpc_config {
    subnet_ids         = var.network.private_subnet
    security_group_ids = [aws_security_group.lambda_aggregator_tron_sg.id]
  }
}

resource "aws_lambda_event_source_mapping" "aggregator_tron_queue_event" {
  depends_on       = [aws_lambda_function.aggregator_tron_functions]
#   event_source_arn = aws_sqs_queue.Aggregator_Tron_Queue.arn
  event_source_arn = var.sqs.aggregator_tron_arn
  function_name    = aws_lambda_function.aggregator_tron_functions.function_name
  batch_size       = 10 # Change as per your requirements
}