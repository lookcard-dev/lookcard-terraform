data "aws_ecr_repository" "repository" {
  name = var.name
}

resource "aws_lambda_function" "sumsub_webhook" {
  count         = var.image_tag == "latest" ? 0 : 1
  function_name = "Sumsub_Webhook"
  role          = aws_iam_role.lambda_function_role.arn
  architectures = ["x86_64"]
  package_type  = "Image"
  image_uri     = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
  timeout       = 60
  memory_size   = 256
  image_config {
    command = ["handlers/index.handler"]
  }
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
      AWS_CLOUDWATCH_LOG_GROUP_NAME = "/lookcard/sumsub-webhook/sumsub"
      SENTRY_DSN                    = jsondecode(data.aws_secretsmanager_secret_version.sentry.secret_string)["SUMSUB_WEBHOOK_DSN"]
      SUMSUB_WEBHOOK_SECRET         = jsondecode(data.aws_secretsmanager_secret_version.sumsub.secret_string)["WEBHOOK_SECRET"]
    }
  }
}

resource "aws_lambda_permission" "api_gateway" {
  count         = var.image_tag == "latest" ? 0 : 1
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = aws_lambda_function.sumsub_webhook[0].function_name

  depends_on = [
    aws_lambda_function.sumsub_webhook,
  ]
}
