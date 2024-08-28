resource "aws_iam_role" "User_API_Task_Execution_Role" {
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
  role       = aws_iam_role.User_API_Task_Execution_Role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "User_API_secrets_manager_read_attachment" {
  role       = aws_iam_role.User_API_Task_Execution_Role.name
  policy_arn = aws_iam_policy.User_API_env_secrets_manager_read_policy.arn
}

resource "aws_iam_role" "User_API_Task_Role" {
  name        = "User-API-Task-Role"
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

