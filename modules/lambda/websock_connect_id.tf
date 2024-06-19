data "aws_iam_policy_document" "web_socket_id" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "web_socket_id" {
  name               = "web_socket_id"
  assume_role_policy = data.aws_iam_policy_document.push_web.json
}




resource "aws_iam_role_policy_attachment" "web_socket_api_policy_attachment" {
  role       = aws_iam_role.web_socket_id.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayInvokeFullAccess"
}





resource "aws_iam_role_policy_attachment" "web_socket_dynamodb_policy_attachment" {
  role       = aws_iam_role.web_socket_id.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaInvocation-DynamoDB"
}



resource "aws_iam_policy" "dynamodb_policy" {
  name        = "DynamoDBUpdateItemPolicy"
  description = "Policy to allow UpdateItem operation on WebSocket DynamoDB table"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = [
        "dynamodb:UpdateItem",
        "dynamodb:Scan"
      ]
      Resource = var.dynamodb_table_arn
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_dynamodb_policy" {
  role       = aws_iam_role.web_socket_id.name 
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}


resource "aws_lambda_function" "web_socket_id" {
  depends_on       = [data.archive_file.lambda]
  function_name    = "web_socket_id"
  role             = aws_iam_role.web_socket_id.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  architectures    = ["x86_64"]
  s3_bucket = "lookcard-lambda-aml-code-testing"
  s3_key = "AM_Websocket_connection.zip"
  timeout          = 300
  # source_code_hash = data.archive_file.lambda.output_base64sha256
}

