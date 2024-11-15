resource "aws_iam_role" "reap_webhook_task_execution_role" {
  name = "reap_webhook_task_execution_role"
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

resource "aws_iam_policy" "reap_webhook_env_secrets_manager_read_policy" {
  name        = "ReapWebhookSecretsReadOnlyPolicy"
  description = "Allows read-only access to Secret - DATABASE and SENTRY"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource" : local.secrets_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "reap_webhook_secrets_manager_read_attachment" {
  role       = aws_iam_role.reap_webhook_task_execution_role.name
  policy_arn = aws_iam_policy.reap_webhook_env_secrets_manager_read_policy.arn
}

resource "aws_iam_role_policy_attachment" "reap_webhook_ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.reap_webhook_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "reap_webhook_task_role" {
  name = "reap-webhook-task-role"
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
  tags = {}
}