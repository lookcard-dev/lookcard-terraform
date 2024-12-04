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
    variables = local.lambda_env_vars
  }
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = aws_lambda_function.firebase_authorizer.function_name
}
