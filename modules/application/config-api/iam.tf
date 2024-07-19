resource "aws_iam_role" "config_api_task_execution_role" {
  name = "config_api_task_execution_role"
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
  role       = aws_iam_role.config_api_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# resource "aws_iam_policy" "config_api_env_secrets_manager_read_policy" {
#   name        = "ConfigAPISecretsReadOnlyPolicy"
#   description = "Allows read-only access to Secret - ConfigAPI-env"
#   policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       for secret in local.iam_secrets : {
#         "Effect" : "Allow",
#         "Action" : [
#           "secretsmanager:GetSecretValue",
#           "secretsmanager:DescribeSecret"
#         ],
#         "Resource" : secret.arn
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "ConfigAPI_secrets_manager_read_attachment" {
#   role       = aws_iam_role.config_api_task_execution_role.name
#   policy_arn = aws_iam_policy.config_api_env_secrets_manager_read_policy.arn
# }

resource "aws_iam_role" "config_api_task_role" {
  name = "config-api-task-role"
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

resource "aws_iam_policy" "config_api_dynamodb_read_write_policy" {
  name        = "ConfigAPIDynamoDbReadWritePolicy"
  description = "Allows read-write access to DynamoDB resources"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:UpdateItem"
        ],
        "Resource" : var.dynamodb_config_api_config_data_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ConfigAPI_dynamodb_attachment" {
  role       = aws_iam_role.config_api_task_execution_role.name
  policy_arn = aws_iam_policy.config_api_dynamodb_read_write_policy.arn
}
resource "aws_iam_policy" "config_api_logging_policy" {
  name        = "ConfigAPILoggingPolicy"
  description = "Allows logging stream"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ],
        "Resource" : aws_cloudwatch_log_group.config_api.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ConfigAPI_logging_attachment" {
  role       = aws_iam_role.config_api_task_execution_role.name
  policy_arn = aws_iam_policy.config_api_logging_policy.arn
}
resource "aws_iam_role_policy_attachment" "ConfigAPI_logging_task_attachment" {
  role       = aws_iam_role.config_api_task_role.name
  policy_arn = aws_iam_policy.config_api_logging_policy.arn
}




# resource "aws_iam_policy" "CryptoAPI_KMS_GenerateDataKey_policy" {
#   name        = "CryptoAPI_KMS_GenerateDataKey_policy"
#   description = "Allows read-only access to Secret - CryptoAPI-env"
#   policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Effect" : "Allow",
#         "Action" : [
#           "kms:Encrypt",
#           "kms:Decrypt",
#           "kms:GenerateDataKey"
#         ],
#         "Resource" : [
#           "${var.config_api_encryption_kms_arn}",
#           "${var.config_api_generator_kms_arn}"
#         ]
#       }
#     ]
#   })
# }

# resource "aws_iam_policy_attachment" "CryptoAPI_KMS_GenerateDataKey_attachment" {
#   name       = "CryptoAPI_KMS_GenerateDataKey_policy"
#   roles      = [aws_iam_role.config_api_task_role.name]
#   policy_arn = aws_iam_policy.CryptoAPI_KMS_GenerateDataKey_policy.arn
# }
