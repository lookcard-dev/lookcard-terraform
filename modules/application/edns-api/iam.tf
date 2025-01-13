resource "aws_iam_role" "edns_api_task_execution_role" {
  name = "Edns-API-Task-Execution-Role"
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

resource "aws_iam_policy" "edns_api_env_secrets_manager_read_policy" {
  name        = "EdnsAPISecretsReadOnlyPolicy"
  description = "Allows read-only access to Secret - EdnsAPI-env and FIREBASE"
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
        "Resource" : local.iam_secrets
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "Edns_API_ECSTaskExecutionRolePolicy_attachment" {
  role       = aws_iam_role.edns_api_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "Edns_API_secrets_manager_read_attachment" {
  role       = aws_iam_role.edns_api_task_execution_role.name
  policy_arn = aws_iam_policy.edns_api_env_secrets_manager_read_policy.arn
}

resource "aws_iam_role" "edns_api_task_role" {
  name = "Edns-API-Task-Role"
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



resource "aws_iam_policy" "edns_api_cloudwatch_putlog_policy" {
  name        = "EdnsAPICloudWatchPutLogPolicy"
  description = "Allows edns-api put log to log group /lookcard/edns-api"
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
            "${aws_cloudwatch_log_group.application_log_group_edns_api.arn}:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "edns_api_cloudwatch_putlog_attachment" {
  role      = aws_iam_role.edns_api_task_role.name
  policy_arn = aws_iam_policy.edns_api_cloudwatch_putlog_policy.arn
}


resource "aws_iam_policy" "edns_api_dynamodb_policy" {
  name        = "EdnsAPIDynamoDBPolicy"
  description = "Allows edns-api to perform operations on DynamoDB tables"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:PutItem",
          "dynamodb:DeleteItem", 
          "dynamodb:UpdateItem",
          "dynamodb:GetItem",
          "dynamodb:Query"
        ],
        "Resource" : [
          "${aws_dynamodb_table.edns_api_domain_data.arn}",
          "${aws_dynamodb_table.edns_api_domain_data.arn}/index/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "edns_api_dynamodb_attachment" {
  role       = aws_iam_role.edns_api_task_role.name
  policy_arn = aws_iam_policy.edns_api_dynamodb_policy.arn
}
