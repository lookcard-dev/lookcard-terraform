resource "aws_iam_role" "profile_api_task_execution_role" {
  name = "profile_api_task_execution_role"
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

resource "aws_iam_role_policy_attachment" "Profile_API_ECSTaskExecutionRolePolicy_attachment" {
  role       = aws_iam_role.profile_api_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_iam_policy" "profile_api_env_secrets_manager_read_policy" {
  name        = "ProfileAPISecretsReadOnlyPolicy"
  description = "Allows read-only access to Secret - ProfileAPI-env"
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

resource "aws_iam_role_policy_attachment" "ProfileAPI_secrets_manager_read_attachment" {
  role       = aws_iam_role.profile_api_task_execution_role.name
  policy_arn = aws_iam_policy.profile_api_env_secrets_manager_read_policy.arn
}

resource "aws_iam_role" "profile_api_task_role" {
  name = "profile-api-task-role"
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

resource "aws_iam_policy" "dynamodb_access_policy" {
  name = "DynamoDBQueryAccessPolicy"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action":[ 
          "dynamodb:Query",
          "dynamodb:PutItem"
        ],
        
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "DynamoDBQueryPolicyAttachment" {
  role       = aws_iam_role.profile_api_task_role.name
  policy_arn = aws_iam_policy.dynamodb_access_policy.arn
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
#           "${var.crypto_api_encryption_kms_arn}",
#           "${var.crypto_api_generator_kms_arn}"
#         ]
#       }
#     ]
#   })
# }

# resource "aws_iam_policy_attachment" "CryptoAPI_KMS_GenerateDataKey_attachment" {
#   name       = "CryptoAPI_KMS_GenerateDataKey_policy"
#   roles      = [aws_iam_role.crypto_api_task_role.name]
#   policy_arn = aws_iam_policy.CryptoAPI_KMS_GenerateDataKey_policy.arn
# }

resource "aws_iam_policy" "profile_api_cloudwatch_putlog_policy" {
  name        = "ProfileAPICloudWatchPutLogPolicy"
  description = "Allows profile-api put log to log group /lookcard/profile-api"
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
            "${aws_cloudwatch_log_group.application_log_group_profile_api.arn}:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "profile_api_cloudwatch_putlog_attachment" {
  role      = aws_iam_role.profile_api_task_role.name
  policy_arn = aws_iam_policy.profile_api_cloudwatch_putlog_policy.arn
}