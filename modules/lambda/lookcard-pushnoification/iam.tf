resource "aws_iam_role" "push_notification_role" {
  name               = "push_notification_role"
  assume_role_policy = data.aws_iam_policy_document.push_notification.json
}


resource "aws_iam_role_policy_attachment" "push_notifi_sqs_policy_attachment" {
  role       = aws_iam_role.push_notification_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}

resource "aws_iam_role_policy_attachment" "push_notifi_vpc_policy_attachment" {
  role       = aws_iam_role.push_notification_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}


resource "aws_iam_policy" "push_notification_secrets_manager_read_policy" {
  name        = "SecretsManagerReadOnlyPolicyPushNotification"
  description = "Allows read-only access to Secrets Manager"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource" : "arn:aws:secretsmanager:ap-southeast-1:975050173595:secret:aml_env-6xOQxJ"
      }
    ]
  })
}


resource "aws_iam_policy_attachment" "Push_Notification_manager_read_attachment" {
  name       = "SecretsManagerReadOnlyAttachment"
  roles      = [aws_iam_role.push_notification_role.name]
  policy_arn = aws_iam_policy.push_notification_secrets_manager_read_policy.arn
}