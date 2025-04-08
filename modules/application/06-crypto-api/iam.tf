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
        "Resource" : [var.secret_arns["DATABASE"], var.secret_arns["SENTRY"], var.secret_arns["TRONSAVE"]]
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
          "${aws_cloudwatch_log_group.app_log_group.arn}:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "signer_key_access" {
  name = "SignerKeyAccessPolicy"
  role = aws_iam_role.task_role.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["kms:Sign", "kms:Verify", "kms:GetPublicKey"],
        "Resource" : [var.kms_key_arns.crypto.worker.alpha, var.kms_key_arns.crypto.liquidity]
      }
    ]
  })
}

resource "aws_iam_role_policy" "sqs_access" {
  name = "SQSAccessPolicy"
  role = aws_iam_role.task_role.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["sqs:SendMessage", "sqs:SendMessageBatch"],
        "Resource" : [var.sqs_queue_arns.sweep_processor, var.sqs_queue_arns.withdrawal_processor]
      }
    ]
  })
}
