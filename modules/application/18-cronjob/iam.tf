resource "aws_iam_role" "task_execution_role" {
  name = "${var.name}-task-execution-role"
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
        "Resource" : [data.aws_secretsmanager_secret.database.arn, data.aws_secretsmanager_secret.sentry.arn]
      }
    ]
  })
}

resource "aws_iam_role" "task_role" {
  name = "${var.name}-task-role"
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

resource "aws_iam_role_policy" "cloudwatch_log" {
  name = "CloudWatchLogPolicy"
  role = aws_iam_role.task_role.id
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
          "${aws_cloudwatch_log_group.batch_account_snapshot_processor_app_log_group.arn}:*",
          "${aws_cloudwatch_log_group.batch_account_statement_generator_app_log_group.arn}:*",
          "${aws_cloudwatch_log_group.account_api_app_log_group.arn}:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "event_role" {
  name = "cronjob-ecs-event-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "ecs_event_policy" {
  name = "ecs-event-policy"
  role = aws_iam_role.event_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecs:RunTask",
          "iam:PassRole"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "dynamodb_policy" {
  name = "dynamodb-policy"
  role = aws_iam_role.task_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem"
        ]
        Effect = "Allow"
        Resource = [
          aws_dynamodb_table.batch_account_statement_generator_history.arn,
          aws_dynamodb_table.batch_account_snapshot_processor_history.arn
        ]
      }
    ]
  })
}
