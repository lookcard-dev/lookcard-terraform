resource "aws_iam_role" "Account_API_Task_Execution_Role" {
  name = "Account-API-Task-Execution-Role"
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
}

resource "aws_iam_policy" "Account_API_env_secrets_manager_read_policy" {
  name        = "AccountAPISecretsReadOnlyPolicy"
  description = "Allows read-only access to Secret - CryptoAPI-env and FIREBASE"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      for secret in local.iam_secrets : {
        "Sid"    : secret.sid,
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource" : secret.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "Account_API_ECSTaskExecutionRolePolicy_attachment" {
  role       = aws_iam_role.Account_API_Task_Execution_Role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "Account_API_secrets_manager_read_attachment" {
  role       = aws_iam_role.Account_API_Task_Execution_Role.name
  policy_arn = aws_iam_policy.Account_API_env_secrets_manager_read_policy.arn
}

resource "aws_iam_role" "Account_API_Task_Role" {
  name = "Account-API-Task-Role"
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
}

resource "aws_iam_policy" "Account_API_SQS_SendMessage" {
  name        = "AccountAPI-SQSSendMessage"
  description = "Allows send message to Lookcard_Notification.fifo SQS Queue"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sqs:SendMessage"
        ],
        "Resource" : [
          # "arn:aws:sqs:ap-southeast-1:576293270682:Lookcard_Notification.fifo",
          # "arn:aws:sqs:ap-southeast-1:576293270682:Crypto_Fund_Withdrawal.fifo"
          "${var.sqs.lookcard_notification_queue_arn}",
          "${var.sqs.crypto_fund_withdrawal_queue_arn}"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "Account_API_SQS_SendMessage_attachment" {
  role       = aws_iam_role.Account_API_Task_Role.name
  policy_arn = aws_iam_policy.Account_API_SQS_SendMessage.arn
}
