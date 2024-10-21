resource "aws_iam_role" "reap_proxy_task_execution_role" {
  name        = "reap-proxy-task-execution-role"
  description = "ECS reap-proxy task execution role"

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

resource "aws_iam_policy" "referral_api_env_secrets_manager_read_policy" {
  name        = "ReapProxySecretsReadOnlyPolicy"
  description = "Policy for read-only access to Reap Proxy environment secrets"

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

resource "aws_iam_role_policy_attachment" "referral_api_ECSTaskExecutionRolePolicy_attachment" {
  role       = aws_iam_role.referral_api_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "referral_api_secrets_manager_read_attachment" {
  role       = aws_iam_role.referral_api_task_execution_role.name
  policy_arn = aws_iam_policy.referral_api_env_secrets_manager_read_policy.arn
}

resource "aws_iam_role" "referral_api_task_role" {
  name        = "referral-api-task-role"
  description = "ECS referral-api task role"

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

resource "aws_iam_policy" "referral_api_cloudwatch_putlog_policy" {
  name        = "ReferralAPICloudWatchPutLogPolicy"
  description = "Allows user api put log to log group /ecs/referral-api and /lookcard/referral-api"
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
            # "${aws_cloudwatch_log_group.ecs_log_group_user_api.arn}:*",
            # "${aws_cloudwatch_log_group.application_log_group_user_api.arn}:*"
            "${local.cloudwatch_log_groups}:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "reap_proxy_cloudwatch_putlog_attachment" {
  role      = aws_iam_role.referral_api_task_role.name
  policy_arn = aws_iam_policy.referral_api_cloudwatch_putlog_policy.arn
}