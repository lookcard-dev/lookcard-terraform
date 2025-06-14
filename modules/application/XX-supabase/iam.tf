resource "aws_iam_role" "task_execution_role" {
  name = "supabase-task-execution-role"
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

resource "aws_iam_role_policy_attachment" "ECSTaskExecutionRolePolicy_attachment" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "secrets_read_only" {
  name = "SecretsReadOnlyPolicy"
  role = aws_iam_role.task_execution_role.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource" : [var.secret_arns["DATABASE"], var.secret_arns["SUPABASE"], var.secret_arns["SMTP"], var.secret_arns["TWILIO"]]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ssm:GetParameter",
          "ssm:GetParameters"
        ],
        "Resource" : [
          aws_ssm_parameter.kong_config.arn
        ]
      }
    ]
  })
}

resource "aws_iam_role" "task_role" {
  name = "supabase-task-role"
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

# Note: App Runner role not needed for public ECR repositories

# IAM role for the App Runner instance
resource "aws_iam_role" "instance_role" {
  name = "supabase-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "tasks.apprunner.amazonaws.com"
        }
      }
    ]
  })
}

# Note: App Runner policy attachment not needed for public ECR repositories

resource "aws_iam_role_policy" "app_runner_secrets_read_only" {
  name = "AppRunnerSecretsReadOnlyPolicy"
  role = aws_iam_role.instance_role.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource" : [
          var.secret_arns["DATABASE"],
          var.secret_arns["SUPABASE"],
        ]
      }
    ]
  })
}
