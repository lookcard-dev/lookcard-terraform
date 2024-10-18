resource "aws_iam_role" "user_api_task_execution_role" {
  name        = "User-API-Task-Execution-Role"
  description = "Role for User API task execution"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = "sts:AssumeRole",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "User_API_env_secrets_manager_read_policy" {
  name        = "UserAPISecretsReadOnlyPolicy"
  description = "Policy for read-only access to User API environment secrets"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid    = "secretSid",
      Effect = "Allow",
      Action = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"],
      Resource = local.iam_secrets
    }]
  })
}

resource "aws_iam_role_policy_attachment" "User_API_ECSTaskExecutionRolePolicy_attachment" {
  role       = aws_iam_role.user_api_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "User_API_secrets_manager_read_attachment" {
  role       = aws_iam_role.user_api_task_execution_role.name
  policy_arn = aws_iam_policy.User_API_env_secrets_manager_read_policy.arn
}

resource "aws_iam_role" "user_api_task_role" {
  name        = "user-api-task-role"
  description = "Role for User API tasks"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = "sts:AssumeRole",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "user_api_cloudwatch_putlog_policy" {
  name        = "UserAPICloudWatchPutLogPolicy"
  description = "Allows user api put log to log group /lookcard/user-api"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
            "logs:CreateLogStream",
            "logs:DescribeLogStreams",
            "logs:PutLogEvents"
        ],
        "Resource" : [
            aws_cloudwatch_log_group.ecs_log_group_user_api.arn,
            aws_cloudwatch_log_group.application_log_group_user_api.arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "user_api_cloudwatch_putlog_attachment" {
  role      = aws_iam_role.user_api_task_role.name
  policy_arn = aws_iam_policy.user_api_cloudwatch_putlog_policy.arn
}