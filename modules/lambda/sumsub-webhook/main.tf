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
}