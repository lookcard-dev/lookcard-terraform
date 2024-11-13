resource "aws_iam_role" "websocket_disconnect_role" {
  name               = "websocket_disconnect_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_sts_policy.json
}

resource "aws_iam_role_policy_attachment" "websocket_disconnect_api_policy_attachment" {
  role       = aws_iam_role.websocket_disconnect_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayInvokeFullAccess"
}

resource "aws_iam_role_policy_attachment" "websocket_disconnect_dynamodb_policy_attachment" {
  role       = aws_iam_role.websocket_disconnect_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaInvocation-DynamoDB"
}

resource "aws_iam_policy" "websocket_disconnect_dynamodb_policy" {
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

resource "aws_iam_role_policy_attachment" "websocket_disconnect_attach_dynamodb_policy" {
  role       = aws_iam_role.websocket_disconnect_role.name
  policy_arn = aws_iam_policy.websocket_disconnect_dynamodb_policy.arn
}

resource "aws_iam_role_policy_attachment" "websocket_disconnect_vpc_policy_attachment" {
  role       = aws_iam_role.websocket_disconnect_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "websocket_disconnect_xraydaemon_write_policy" {
  role       = aws_iam_role.websocket_disconnect_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}