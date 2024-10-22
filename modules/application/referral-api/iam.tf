resource "aws_iam_role" "referral_api_task_execution_role" {
  name        = "referral-api-task-execution-role"
  description = "ECS referral-api task execution role"

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
  name        = "ReferralAPISecretsReadOnlyPolicy"
  description = "Policy for read-only access to Referral API environment secrets"

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
  description = "Allows referral api put log to log group /lookcard/referral-api"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
            "logs:DescribeLogStreams",
            "logs:PutLogEvents"
        ],
        "Resource" : [
            "${aws_cloudwatch_log_group.application_log_group_referral_api.arn}:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "referral_api_cloudwatch_putlog_attachment" {
  role      = aws_iam_role.referral_api_task_role.name
  policy_arn = aws_iam_policy.referral_api_cloudwatch_putlog_policy.arn
}