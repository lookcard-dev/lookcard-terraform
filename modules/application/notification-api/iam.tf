resource "aws_iam_role" "notification_api_task_execution_role" {
  name = "notification-api-task-execution-role"
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

resource "aws_iam_policy" "notification_api_env_secrets_manager_read_policy" {
  name        = "NotificationAPISecretsReadOnlyPolicy"
  description = "Allows read-only access to Secret - NotificationAPI-env and FIREBASE"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid"    : "secretSid",
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

resource "aws_iam_role_policy_attachment" "notification_api_ECSTaskExecutionRolePolicy_attachment" {
  role       = aws_iam_role.notification_api_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "notification_api_secrets_manager_read_attachment" {
  role       = aws_iam_role.notification_api_task_execution_role.name
  policy_arn = aws_iam_policy.notification_api_env_secrets_manager_read_policy.arn
}

resource "aws_iam_role" "notification_api_task_role" {
  name = "notification-api-task-role"
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

resource "aws_iam_policy" "notification_api_cloudwatch_putlog_policy" {
  name        = "NotificationAPICloudWatchPutLogPolicy"
  description = "Allows notification api put log to log group /ecs/notification-api"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
            "logs:DescribeLogStreams",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ],
        "Resource" : [
            "${aws_cloudwatch_log_group.application_log_group_notification_api.arn}:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "notification_api_cloudwatch_putlog_attachment" {
  role      = aws_iam_role.notification_api_task_role.name
  policy_arn = aws_iam_policy.notification_api_cloudwatch_putlog_policy.arn
}

