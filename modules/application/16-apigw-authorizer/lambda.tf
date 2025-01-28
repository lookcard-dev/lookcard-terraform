data "aws_ecr_repository" "repository"{
  name = var.name
}

data "aws_secretsmanager_secret" "sentry" {
  name = "SENTRY"
}

data "aws_secretsmanager_secret_version" "sentry" {
  secret_id = data.aws_secretsmanager_secret.sentry.id
}

resource "aws_lambda_function" "firebase_authorizer" {
  count = var.image_tag == "latest" ? 0 : 1
  function_name = "Firebase_Authorizer"
  role          = aws_iam_role.lambda_function_role.arn
  architectures = ["x86_64"]
  package_type  = "Image"
  image_uri     = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
  image_config {
    command = ["handlers/firebase.handler"]
  }
  timeout     = 60
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
        RUNTIME_ENVIRONMENT = var.runtime_environment
        AWS_XRAY_DAEMON_ENDPOINT = "xray.daemon.lookcard.local:2337"
        AWS_CLOUDWATCH_LOG_GROUP_NAME = "/lookcard/apigw-authorizer/firebase"
        SENTRY_DSN = jsondecode(data.aws_secretsmanager_secret_version.sentry.secret_string)["FIREBASE_AUTHORIZER_DSN"]
    }
  }
}

resource "aws_lambda_permission" "api_gateway" {
  count = var.image_tag == "latest" ? 0 : 1
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = aws_lambda_function.firebase_authorizer[0].function_name
}
