resource "aws_lambda_function" "sumsub_webhook" {
  function_name = "sumsub-webhook"
  role          = aws_iam_role.lambda_sumbsub_webhook.arn
  architectures = ["x86_64"]
  package_type  = "Image"
  image_uri     = "${var.image.url}:${var.image.tag}"
  timeout       = 300
  memory_size   = 512

  tracing_config {
    mode = "Active"
  }

  vpc_config {
    subnet_ids         = var.network.private_subnet
    security_group_ids = [aws_security_group.lambda_sumsub_webhook_sg.id]
  }

  environment {
    variables = {
      SENTRY_DSN = "https://450b23821b84a6c32e52351b4b4210e9@o4507299807428608.ingest.de.sentry.io/4508150005891152",
      RUNTIME_ENVIRONMENT = var.env_tag,
      AWS_XRAY_DAEMON_ENDPOINT = "xray.daemon.lookcard.local:2337"
    }
  }
}

resource "aws_lambda_permission" "allow_api_gw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = aws_lambda_function.sumsub_webhook.function_name
}