resource "aws_iam_role" "notification_dispatcher" {
  name = "notification-dispatcher-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "notification_dispatcher_secrets_manager_read_policy" {
  name        = "Notification-Dispatcher-SecretsReadOnlyPolicy"
  description = "Allows read-only access to Secret - SYSTEM_CRYPTO_WALLET, COINRANKING and ELLIPTIC"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource" : local.secrets
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "notification_dispatcher_env_secrets_manager_read_attachment" {
  role       = aws_iam_role.notification_dispatcher.name
  policy_arn = aws_iam_policy.notification_dispatcher_secrets_manager_read_policy.arn
}

resource "aws_iam_role_policy_attachment" "notification_dispatcher_basic_execution_notification" {
  role       = aws_iam_role.notification_dispatcher.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}
resource "aws_iam_role_policy_attachment" "notification_dispatcher_vpc_execution_notification" {
  role       = aws_iam_role.notification_dispatcher.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "notification_dispatcher_xraydaemon_write_policy" {
  role       = aws_iam_role.notification_dispatcher.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}