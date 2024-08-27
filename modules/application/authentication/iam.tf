resource "aws_iam_role" "ecs_task_role" {
  name = "ecstaskrole"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    # Add tags if needed
  }
}

resource "aws_iam_role_policy_attachment" "ecs_role" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "secrets_manager_read_policy" {
  name        = "SecretsManagerReadOnlyPolicy"
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
        "Resource" : local.iam_secrets
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "secrets_manager_read_attachment" {
  name       = "SecretsManagerReadOnlyAttachment"
  roles      = [aws_iam_role.ecs_task_role.name]
  policy_arn = aws_iam_policy.secrets_manager_read_policy.arn
}

resource "aws_iam_policy" "Withdrawal_SQS_policy" {
  name        = "SQS_Access_Withdrawal"
  description = "Allows read-only access to Secrets Manager"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sqs:SendMessage"
        ],
        "Resource" : "${var.sqs.crypto_fund_withdrawal_queue_arn}"
      }
    ]
  })
}
resource "aws_iam_policy_attachment" "Withdrawal__SQS_attachment" {
  name       = "SQSSendmessageAttachmentwithdrawal"
  roles      = [aws_iam_role.ecs_task_role.name]
  policy_arn = aws_iam_policy.Withdrawal_SQS_policy.arn
}