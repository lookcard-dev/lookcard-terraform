data "aws_ecr_image" "apigw_authorizer" {
  repository_name = "apigw-authorizer"
  most_recent     = true
}

resource "aws_lambda_function" "firebase_authorizer" {
  function_name = "Firebase_Authorizer"
  role          = aws_iam_role.lambda_firebase_authorizer.arn
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
    security_group_ids = [aws_security_group.lambda_firebase_authorizer_sg.id]
  }

  image_config {
    command = ["handlers/firebase.handler"]
  }

  environment {
    variables = {
      SENTRY_DSN = "https://a6dd019878e8998d0117d8f298cbce5f@o4507299807428608.ingest.de.sentry.io/4508289701052496",
      RUNTIME_ENVIRONMENT = var.env_tag,
      AWS_XRAY_DAEMON_ENDPOINT = "xray.daemon.lookcard.local:2337"
    }
  }
}