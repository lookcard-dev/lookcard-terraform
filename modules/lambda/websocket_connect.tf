resource "aws_lambda_function" "web_socket_connect" {
  function_name = "web_socket_connect"
  role          = aws_iam_role.websocket_connect_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  s3_bucket     = var.lambda_code.s3_bucket
  s3_key        = var.lambda_code.websocket_connect_s3key
  timeout       = 300
}


resource "aws_iam_role" "websocket_connect_role" {
  name               = "websocket_connect_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_sts_policy.json
}

resource "aws_iam_role_policy_attachment" "web_socket_api_policy_attachment" {
  role       = aws_iam_role.websocket_connect_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayInvokeFullAccess"
}

resource "aws_iam_role_policy_attachment" "web_socket_dynamodb_policy_attachment" {
  role       = aws_iam_role.websocket_connect_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaInvocation-DynamoDB"
}

resource "aws_iam_policy" "dynamodb_policy" {
  name        = "DynamoDBUpdateItemPolicy"
  description = "Policy to allow UpdateItem operation on WebSocket DynamoDB table"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "dynamodb:UpdateItem",
        "dynamodb:Scan"
      ]
      Resource = var.ddb_websocket_arn
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_dynamodb_policy" {
  role       = aws_iam_role.websocket_connect_role.name
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}

resource "aws_iam_role_policy_attachment" "web_socket_vpc_policy_attachment" {
  role       = aws_iam_role.websocket_connect_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}


