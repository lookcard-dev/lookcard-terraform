data "aws_ecr_repository" "repository" {
  name = var.name
}

data "aws_secretsmanager_secret_version" "sentry" {
  secret_id = var.secret_arns["SENTRY"]
}

resource "aws_lambda_function" "sweep_processor" {
  count         = var.image_tag == "latest" ? 0 : 1
  function_name = "Crypto_Processor-Sweep_Processor"
  role          = aws_iam_role.lambda_function_role.arn
  architectures = ["x86_64"]
  package_type  = "Image"
  image_uri     = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
  image_config {
    command = ["src/workflows/sweep/index.handler"]
  }
  timeout     = 900
  memory_size = 256
  tracing_config {
    mode = "Active"
  }
  vpc_config {
    subnet_ids         = var.network.private_subnet_ids
    security_group_ids = [aws_security_group.security_group.id]
  }
  environment {
    variables = {
      RUNTIME_ENVIRONMENT           = var.runtime_environment
      AWS_XRAY_DAEMON_ENDPOINT      = "xray.daemon.lookcard.local:2337"
      AWS_CLOUDWATCH_LOG_GROUP_NAME = "/lookcard/crypto-processor/sweep"
      SENTRY_DSN                    = jsondecode(data.aws_secretsmanager_secret_version.sentry.secret_string)["CRYPTO_PROCESSOR_DSN"]
      ELLIPTIC_SECRET_ARN           = var.secret_arns["ELLIPTIC"]
    }
  }
}

resource "aws_lambda_event_source_mapping" "sweep_processor_queue_event" {
  count            = var.image_tag == "latest" ? 0 : 1
  depends_on       = [aws_lambda_function.sweep_processor[0]]
  event_source_arn = aws_sqs_queue.sweep_processor.arn
  function_name    = aws_lambda_function.sweep_processor[0].function_name
  batch_size       = 10
}

resource "aws_lambda_function" "withdrawal_processor" {
  count         = var.image_tag == "latest" ? 0 : 1
  function_name = "Crypto_Processor-Withdrawal_Processor"
  role          = aws_iam_role.lambda_function_role.arn
  architectures = ["x86_64"]
  package_type  = "Image"
  image_uri     = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
  image_config {
    command = ["src/workflows/withdrawal/index.handler"]
  }
  timeout     = 900
  memory_size = 256
  tracing_config {
    mode = "Active"
  }
  vpc_config {
    subnet_ids         = var.network.private_subnet_ids
    security_group_ids = [aws_security_group.security_group.id]
  }
  environment {
    variables = {
      RUNTIME_ENVIRONMENT           = var.runtime_environment
      AWS_XRAY_DAEMON_ENDPOINT      = "xray.daemon.lookcard.local:2337"
      AWS_CLOUDWATCH_LOG_GROUP_NAME = "/lookcard/crypto-processor/withdrawal"
      SENTRY_DSN                    = jsondecode(data.aws_secretsmanager_secret_version.sentry.secret_string)["CRYPTO_PROCESSOR_DSN"]
      ELLIPTIC_SECRET_ARN           = var.secret_arns["ELLIPTIC"]
    }
  }
}

resource "aws_lambda_event_source_mapping" "withdrawal_processor_queue_event" {
  count            = var.image_tag == "latest" ? 0 : 1
  depends_on       = [aws_lambda_function.withdrawal_processor[0]]
  event_source_arn = aws_sqs_queue.withdrawal_processor.arn
  function_name    = aws_lambda_function.withdrawal_processor[0].function_name
  batch_size       = 10
}
