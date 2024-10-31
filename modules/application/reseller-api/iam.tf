resource "aws_iam_role" "reseller_api_task_execution_role" {
  name        = "reseller-api-task-execution-role"
  description = "ECS reseller-api task execution role"

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

resource "aws_iam_policy" "reseller_api_env_secrets_manager_read_policy" {
  name        = "ResellerAPISecretsReadOnlyPolicy"
  description = "Policy for read-only access to reseller-api environment secrets"

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

resource "aws_iam_role_policy_attachment" "reseller_api_ECSTaskExecutionRolePolicy_attachment" {
  role       = aws_iam_role.reseller_api_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "reseller_api_secrets_manager_read_attachment" {
  role       = aws_iam_role.reseller_api_task_execution_role.name
  policy_arn = aws_iam_policy.reseller_api_env_secrets_manager_read_policy.arn
}

resource "aws_iam_role" "reseller_api_task_role" {
  name        = "reseller-api-task-role"
  description = "ECS reseller-api task role"

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

resource "aws_iam_policy" "reseller_api_cloudwatch_putlog_policy" {
  name        = "ResellerAPICloudWatchPutLogPolicy"
  description = "Allows reseller-api put log to log group /lookcard/reseller-api"
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
            "${aws_cloudwatch_log_group.application_log_group_reseller_api.arn}:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "reseller_api_cloudwatch_putlog_attachment" {
  role      = aws_iam_role.reseller_api_task_role.name
  policy_arn = aws_iam_policy.reseller_api_cloudwatch_putlog_policy.arn
}