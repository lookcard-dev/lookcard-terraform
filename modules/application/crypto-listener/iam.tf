resource "aws_iam_role" "crypto_listener_getblock_task_exec_role" {
  name = "crypto-listener-getblock-task-execution-role"
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
resource "aws_iam_role" "crypto_listener_trongrid_task_exec_role" {
  name = "crypto-listener-trongrid-task-execution-role"
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

resource "aws_iam_role_policy_attachment" "crypto_listener_getblock_ecstaskexecrolepolicy_attachment" {
  role       = aws_iam_role.crypto_listener_getblock_task_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "crypto_listener_trongrid_ecstaskexecrolepolicy_attachment" {
  role       = aws_iam_role.crypto_listener_trongrid_task_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "crypto_listener_getblock_env_secrets_manager_read_policy" {
  name        = "crypto-listener-getblock-SecretsReadOnlyPolicy"
  description = "Allows read-only access to Secret - GETBLOCK and DATABASE"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource" : local.iam_secrets_getblock
      }
    ]
  })
}

resource "aws_iam_policy" "crypto_listener_trongrid_env_secrets_manager_read_policy" {
  name        = "crypto-listener-trongrid-SecretsReadOnlyPolicy"
  description = "Allows read-only access to Secret - TRONGRID and DATABASE"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource" : local.iam_secrets_trongrid
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "crypto_listener_getblock_secrets_manager_read_attachment" {
  role       = aws_iam_role.crypto_listener_getblock_task_exec_role.name
  policy_arn = aws_iam_policy.crypto_listener_getblock_env_secrets_manager_read_policy.arn
}

resource "aws_iam_role_policy_attachment" "crypto_listener_trongrid_secrets_manager_read_attachment" {
  role       = aws_iam_role.crypto_listener_trongrid_task_exec_role.name
  policy_arn = aws_iam_policy.crypto_listener_trongrid_env_secrets_manager_read_policy.arn
}

resource "aws_iam_role" "crypto_listener_getblock_task_role" {
  name = "crypto-listener-getblock-task-role"
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

resource "aws_iam_role" "crypto_listener_trongrid_task_role" {
  name = "crypto-listener-trongrid-task-role"
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

resource "aws_iam_policy" "transaction_listener_sqs_send_message_policy" {
  name        = "SQSSendMessagePolicy"
  description = "Allows sending messages to a specific SQS queue"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:SendMessage"
        ]
        Resource = var.sqs.cryptocurrency_sweeper.arn
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "crypto_listener_getblock_sqs_attachment" {
  role       = aws_iam_role.crypto_listener_trongrid_task_role.name
  policy_arn = aws_iam_policy.transaction_listener_sqs_send_message_policy.arn
}

resource "aws_iam_role_policy_attachment" "crypto_listener_trongrid_sqs_attachment" {
  role       = aws_iam_role.crypto_listener_trongrid_task_role.name
  policy_arn = aws_iam_policy.transaction_listener_sqs_send_message_policy.arn
}

resource "aws_iam_policy" "crypto_listener_getblock_cloudwatch_putlog_policy" {
  name        = "crypto-listener-getblock-CloudWatchPutLogPolicy"
  description = "Allows crypto api put log to log group /lookcard/crypto-listener/tron/nile/getblock"
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
            "${aws_cloudwatch_log_group.application_log_crypto_listener_getblock.arn}:*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "crypto_listener_trongrid_cloudwatch_putlog_policy" {
  name        = "crypto-listener-trongrid-CloudWatchPutLogPolicy"
  description = "Allows crypto api put log to log group /lookcard/crypto-listener/tron/nile/trongrid"
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
            "${aws_cloudwatch_log_group.application_log_crypto_listener_trongrid.arn}:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "crypto_listener_getblock_cloudwatch_putlog_attachment" {
  role      = aws_iam_role.crypto_listener_getblock_task_role.name
  policy_arn = aws_iam_policy.crypto_listener_getblock_cloudwatch_putlog_policy.arn
}

resource "aws_iam_role_policy_attachment" "crypto_listener_trongrid_cloudwatch_putlog_attachment" {
  role      = aws_iam_role.crypto_listener_trongrid_task_role.name
  policy_arn = aws_iam_policy.crypto_listener_trongrid_cloudwatch_putlog_policy.arn
}

resource "aws_iam_role" "ecs_instance_role" {
  name = "ecs-instance-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Principal" : {
          "Service" : "ec2.amazonaws.com",
        }
      }
    ]
  })
}

resource "aws_iam_policy" "ecs_instance_role_cloudwatch_policy" {
  name        = "ecs-instance-role-cloudwatch-policy"
  description = "allow create, put and describe cloudwatch log"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        "Resource" : [
          "arn:aws:logs:*:*:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecsInstanceRole-AmazonEC2ContainerServiceforEC2Role-attachment" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecsInstanceRole-cloudwatch-policy-attachment" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = aws_iam_policy.ecs_instance_role_cloudwatch_policy.arn
}

resource "aws_iam_instance_profile" "ecs-instance-profile" {
  name = "ecs-instance-profile"
  role = aws_iam_role.ecs_instance_role.name
}

