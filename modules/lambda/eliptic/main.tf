resource "aws_lambda_function" "eliptic" {
  function_name = "elliptic"
  role          = aws_iam_role.eliptic_role.arn
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  s3_bucket     = var.lambda_code.s3_bucket
  s3_key        = var.lambda_code.elliptic_s3key
  timeout       = 300

  vpc_config {
    subnet_ids         = var.network.private_subnet
    security_group_ids = [aws_security_group.eliptic_sg.id]
  }
}

resource "aws_lambda_event_source_mapping" "eliptic" {
  depends_on       = [aws_lambda_function.eliptic]
  event_source_arn = var.sqs.eliptic_arn
  function_name    = aws_lambda_function.eliptic.arn
  batch_size       = 10 # Change as per your requirements
}