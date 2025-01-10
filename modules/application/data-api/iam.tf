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

resource "aws_iam_policy" "data_api_env_secrets_manager_read_policy" {
  name        = "DataAPISecretsReadOnlyPolicy"
  description = "Allows read-only access to Secret - DataAPI-env and FIREBASE"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid"    : "secretSid",
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

resource "aws_iam_role_policy_attachment" "data_api_ECSTaskExecutionRolePolicy_attachment" {
  role       = aws_iam_role.data_api_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "data_api_secrets_manager_read_attachment" {
  role       = aws_iam_role.data_api_task_execution_role.name
  policy_arn = aws_iam_policy.data_api_env_secrets_manager_read_policy.arn
}

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

resource "aws_iam_policy" "data_api_cloudwatch_putlog_policy" {
  name        = "DataAPICloudWatchPutLogPolicy"
  description = "Allows data api put log to log group /lookcard/data-api"
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
            "${aws_cloudwatch_log_group.application_log_group_data_api.arn}:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "data_api_cloudwatch_putlog_attachment" {
  role      = aws_iam_role.data_api_task_role.name
  policy_arn = aws_iam_policy.data_api_cloudwatch_putlog_policy.arn
}

resource "aws_iam_policy" "data_api_kms_policy" {
  name        = "DataAPIKMSPolicy"
  description = ""
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
            "kms:GenerateDataKey",
            "kms:Encrypt",
            "kms:Decrypt"
        ],
        "Resource" : [
            "arn:aws:kms:ap-southeast-1:227720554629:key/ce295816-2522-43cf-a880-4b8410c86fc2",
            "arn:aws:kms:ap-southeast-1:227720554629:key/084a9037-d9eb-4f00-983f-199c318d171c",
            "arn:aws:kms:ap-southeast-1:227720554629:key/19d0925a-c261-461c-bd97-78f90805165f",
            "arn:aws:kms:ap-southeast-1:227720554629:key/acfda31a-7873-4a05-8b1f-ac0f98a8650b",
            "arn:aws:kms:ap-southeast-1:227720554629:key/14571f7c-5a75-4385-bd8e-4d3c051d2541",
            "arn:aws:kms:ap-southeast-1:227720554629:key/bd7162eb-db84-4a47-a87b-99e34c96d84e"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "data_api_kms_policy_attachment" {
  role      = aws_iam_role.data_api_task_role.name
  policy_arn = aws_iam_policy.data_api_kms_policy.arn
}

resource "aws_iam_policy" "data_api_dynamodb_read_write_policy" {
  name        = "DataAPIDynamoDbReadWritePolicy"
  description = "Allows get, put and query to DynamoDB resources"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query"
        ],
        "Resource" : [
          aws_dynamodb_table.data_api_data.arn,
          aws_dynamodb_table.data_api_nonce.arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "data_api_dynamodb_read_write_attachment" {
  role       = aws_iam_role.data_api_task_role.name
  policy_arn = aws_iam_policy.data_api_dynamodb_read_write_policy.arn
}