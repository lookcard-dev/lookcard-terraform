resource "aws_iam_role" "lookcard_notification_role" {
  name = "Lookcard-Notification-role"
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

resource "aws_iam_policy" "lookcard_notification_secrets_manager_read_policy" {
  name        = "Loocard-Notification-SecretsReadOnlyPolicy"
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
        "Resource" : [
            "${var.secret_manager.notification_env_secret_arn}"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lookcard_notification_env_secrets_manager_read_attachment" {
  role       = aws_iam_role.lookcard_notification_role.name
  policy_arn = aws_iam_policy.lookcard_notification_secrets_manager_read_policy.arn
}

resource "aws_iam_role_policy_attachment" "Lambda_basic_execution_notification" {
  role       = aws_iam_role.lookcard_notification_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}
resource "aws_iam_role_policy_attachment" "Lambda_vpc_execution_notification" {
  role       = aws_iam_role.lookcard_notification_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lookcard_notification_xraydaemon_write_policy" {
  role       = aws_iam_role.lookcard_notification_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}