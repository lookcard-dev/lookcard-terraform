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

resource "aws_iam_policy" "config_api_log_stream_policy" {
  name        = "ConfigAPILogStreamPolicy"
  description = "Allows log stream"
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
        "Resource" : aws_cloudwatch_log_stream.config_api.arn 
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ConfigAPI_logging_task_attachment" {
  role       = aws_iam_role.config_api_task_role.name
  policy_arn = aws_iam_policy.config_api_log_stream_policy.arn
}

