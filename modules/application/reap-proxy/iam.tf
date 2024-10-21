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

resource "aws_iam_policy" "reap_proxy_env_secrets_manager_read_policy" {
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

resource "aws_iam_role_policy_attachment" "reap_proxy_ECSTaskExecutionRolePolicy_attachment" {
  role       = aws_iam_role.reap_proxy_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "reap_proxy_secrets_manager_read_attachment" {
  role       = aws_iam_role.reap_proxy_task_execution_role.name
  policy_arn = aws_iam_policy.reap_proxy_env_secrets_manager_read_policy.arn
}

resource "aws_iam_role" "reap_proxy_task_role" {
  name        = "reap-proxy-task-role"
  description = "ECS reap-proxy task role"

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