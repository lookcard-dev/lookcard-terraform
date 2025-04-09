
# IAM role for App Runner to pull images from ECR
resource "aws_iam_role" "app_runner_role" {
  name = "${var.name}-app-runner-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "build.apprunner.amazonaws.com"
        }
      }
    ]
  })
}

# IAM role for the App Runner instance
resource "aws_iam_role" "instance_role" {
  name = "${var.name}-instance-role"

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

# Attach necessary policies to the roles (adjust according to your needs)
resource "aws_iam_role_policy_attachment" "app_runner_policy" {
  role       = aws_iam_role.app_runner_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

resource "aws_iam_role_policy" "secrets_read_only" {
  name = "SecretsReadOnlyPolicy"
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
        "Resource" : [var.secret_arns["WALLET"], var.secret_arns["SENTRY"], var.secret_arns["MICROSOFT"]]
      }
    ]
  })


}