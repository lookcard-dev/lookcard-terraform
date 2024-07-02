
resource "aws_security_group" "Transaction-Listener-SG" {
  depends_on  = [var.vpc_id]
  name        = "Transaction-Listener-Service-Security-Group"
  description = "Security group for Transaction Listener services"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Transaction-Listener-Security-Group"
  }
}

data "aws_secretsmanager_secret" "trongrid_secret" {
  name = "TRONGRID"
}


resource "aws_iam_role" "Transaction_Listener_Task_Execution_Role" {
  name = "Transaction-Listener-Task-Execution-Role"
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

resource "aws_iam_role_policy_attachment" "Transaction_Listener_ECSTaskExecutionRolePolicy_attachment" {
  role       = aws_iam_role.Transaction_Listener_Task_Execution_Role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "Transaction_Listener_env_secrets_manager_read_policy" {
  name        = "TransactionListenerSecretsReadOnlyPolicy"
  description = "Allows read-only access to Secret - TRON"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource" : [
          "${data.aws_secretsmanager_secret.trongrid_secret.arn}"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "Transaction_Listener_secrets_manager_read_attachment" {
  role       = aws_iam_role.Transaction_Listener_Task_Execution_Role.name
  policy_arn = aws_iam_policy.Transaction_Listener_env_secrets_manager_read_policy.arn
}

resource "aws_iam_role" "Transaction_Listener_Task_Role" {
  name = "Transaction-Listener-Task-Role"
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

resource "aws_iam_policy" "Transaction_Listener_ddb_policy" {
  name        = "Transaction-Listener-ReadWriteDDB"
  description = "Allows read-only access to Secret - TRONGRID"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:*"
        ],
        "Resource" : [
          var.dynamodb_crypto_transaction_listener_arn
        ]
        # "Resource" : [
        #     "arn:aws:dynamodb:ap-southeast-1:576293270682:table/Crypto-Transaction-Listener-Block-Record"
        # ]
      }
    ]
  })
}

resource "aws_iam_policy" "Transaction_Listener_sqs_send_message_policy" {
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
        Resource = var.aggregator_tron_sqs_arn
        # Resource  = "arn:aws:sqs:ap-southeast-1:576293270682:Aggregator_Tron.fifo"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "Transaction_Listener_ddb_attachment" {
  role       = aws_iam_role.Transaction_Listener_Task_Role.name
  policy_arn = aws_iam_policy.Transaction_Listener_ddb_policy.arn
}


resource "aws_iam_role_policy_attachment" "Transaction_Listener_sqs_attachment" {
  role       = aws_iam_role.Transaction_Listener_Task_Role.name
  policy_arn = aws_iam_policy.Transaction_Listener_sqs_send_message_policy.arn
}


data "aws_secretsmanager_secret" "TRONGRID_secret" {
  name = "tron"
}


resource "aws_ecs_service" "Transaction_Listener_Service_1" {
  name            = "Transaction-Listener-1"
  task_definition = aws_ecs_task_definition.Transaction-Listener-1.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  cluster         = var.cluster

  network_configuration {
    subnets         = [var.network.private_subnet[1]]
    security_groups = [aws_security_group.Transaction-Listener-SG.id]
  }
}


