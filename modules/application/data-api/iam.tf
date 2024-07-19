resource "aws_iam_role" "data_api_task_execution_role" {
  name = "data-api-task-execution-role"
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

# resource "aws_iam_policy" "data_api_env_secrets_manager_read_policy" {
#   name        = "AccountAPISecretsReadOnlyPolicy"
#   description = "Allows read-only access to Secret - CryptoAPI-env and FIREBASE"
#   policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Sid"    : "secretSid",
#         "Effect" : "Allow",
#         "Action" : [
#           "secretsmanager:GetSecretValue",
#           "secretsmanager:DescribeSecret"
#         ],
#         "Resource" : local.iam_secrets
#       }
#     ]
#   })
# }

resource "aws_iam_role_policy_attachment" "data_api_ECSTaskExecutionRolePolicy_attachment" {
  role       = aws_iam_role.data_api_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# resource "aws_iam_role_policy_attachment" "data_api_secrets_manager_read_attachment" {
#   role       = aws_iam_role.data_api_task_execution_role.name
#   policy_arn = aws_iam_policy.data_api_env_secrets_manager_read_policy.arn
# }

resource "aws_iam_role" "data_api_task_role" {
  name = "data-api-task-role"
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


