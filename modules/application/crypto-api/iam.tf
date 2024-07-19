resource "aws_iam_role" "crypto_api_task_execution_role" {
  name = "crypto_api_task_execution_role"
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

resource "aws_iam_role_policy_attachment" "Crypto_API_ECSTaskExecutionRolePolicy_attachment" {
  role       = aws_iam_role.crypto_api_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "crypto_api_env_secrets_manager_read_policy" {
  name        = "CryptoAPISecretsReadOnlyPolicy"
  description = "Allows read-only access to Secret - CryptoAPI-env"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "CryptoAPI_secrets_manager_read_attachment" {
  role       = aws_iam_role.crypto_api_task_execution_role.name
  policy_arn = aws_iam_policy.crypto_api_env_secrets_manager_read_policy.arn
}

resource "aws_iam_role" "crypto_api_task_role" {
  name = "crypto-api-task-role"
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

resource "aws_iam_policy" "CryptoAPI_KMS_GenerateDataKey_policy" {
  name        = "CryptoAPI_KMS_GenerateDataKey_policy"
  description = "Allows read-only access to Secret - CryptoAPI-env"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ],
        "Resource" : [
          var.crypto_api_encryption_kms_arn,
          var.crypto_api_generator_kms_arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "CryptoAPI_KMS_GenerateDataKey_attachment" {
  role       = aws_iam_role.crypto_api_task_role.name
  policy_arn = aws_iam_policy.CryptoAPI_KMS_GenerateDataKey_policy.arn
}
