resource "aws_lambda_function" "push_notification_function" {
  function_name = "Push_Notification"
  role          = aws_iam_role.push_notification_role.arn
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  architectures = ["x86_64"]
  s3_bucket     = "${var.general_config.env}-lambda-aml-code-${var.general_config.env}"
  s3_key        = "lookcard-pushnoification.zip"
  timeout       = 300
  # source_code_hash = data.archive_file.lambda.output_base64sha256
  vpc_config {
    subnet_ids         = var.network.private_subnet
    security_group_ids = [aws_security_group.push_notification.id]
  }
}
