resource "aws_iam_role" "websocket_role" {
  name               = "websocket_role"
  assume_role_policy = data.aws_iam_policy_document.websocket.json
}

resource "aws_iam_role_policy_attachment" "websocket_sqs_policy_attachment" {
  role       = aws_iam_role.websocket_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}


resource "aws_iam_role_policy_attachment" "websocket_api_policy_attachment" {
  role       = aws_iam_role.websocket_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayInvokeFullAccess"
}


resource "aws_iam_policy" "websocket_secrets_manager_read_policy" {
  name        = "SecretsManagerReadOnlyPolicyPushMeassageWeb"
  description = "Allows read-only access to Secrets Manager"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Statement1",
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource" : "${var.secret_manager.aml_env_secret_arn}"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "websocket_secrets_manager_read_attachment" {
  name       = "SecretsManagerReadOnlyAttachment"
  roles      = [aws_iam_role.websocket_role.name]
  policy_arn = aws_iam_policy.websocket_secrets_manager_read_policy.arn
}

resource "aws_iam_role_policy_attachment" "websocket_xraydaemon_write_policy" {
  role       = aws_iam_role.websocket_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}
