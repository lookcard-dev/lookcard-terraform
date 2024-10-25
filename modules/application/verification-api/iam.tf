resource "aws_iam_role" "verificaiton_api_task_execution_role" {
  name        = "verificaiton-api-task-execution-role"
  description = "Role for verificaiton-api task execution"

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

resource "aws_iam_policy" "verificaiton_api_env_secrets_manager_read_policy" {
  name        = "VerificaitonAPISecretsReadOnlyPolicy"
  description = "Policy for read-only access to verificaiton-api environment secrets"

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

resource "aws_iam_role_policy_attachment" "verificaiton_api_ECSTaskExecutionRolePolicy_attachment" {
  role       = aws_iam_role.verificaiton_api_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "verificaiton_api_secrets_manager_read_attachment" {
  role       = aws_iam_role.verificaiton_api_task_execution_role.name
  policy_arn = aws_iam_policy.verificaiton_api_env_secrets_manager_read_policy.arn
}

resource "aws_iam_role" "verificaiton_api_task_role" {
  name        = "verificaiton-api-task-role"
  description = "Role for verificaiton-api tasks"

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

resource "aws_iam_policy" "verificaiton_api_cloudwatch_putlog_policy" {
  name        = "VerificaitonAPICloudWatchPutLogPolicy"
  description = "Allows verificaiton-api put log to log group /lookcard/verificaiton-api"
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
            "${aws_cloudwatch_log_group.application_log_group_verification_api.arn}:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "verification_api_cloudwatch_putlog_attachment" {
  role      = aws_iam_role.verificaiton_api_task_role.name
  policy_arn = aws_iam_policy.verificaiton_api_cloudwatch_putlog_policy.arn
}