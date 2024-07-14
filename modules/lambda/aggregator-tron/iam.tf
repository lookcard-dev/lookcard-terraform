resource "aws_iam_role" "lambda_aggregator_tron_roles" {
  name = "lambda-aggregator-tron-roles"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_aggregator_tron_secrets_manager_read_policys" {
  name        = "lambda-aggregator-tron-secretsReadOnlyPolicys"
  description = "Allows read-only access to Secret - SYSTEM_CRYPTO_WALLET, COINRANKING and ELLIPTIC"
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
          "arn:aws:secretsmanager:ap-southeast-1:975050173595:secret:SYSTEM_CRYPTO_WALLET-biOCGt",
          "arn:aws:secretsmanager:ap-southeast-1:975050173595:secret:COINRANKING-5Js8eX",
          "arn:aws:secretsmanager:ap-southeast-1:975050173595:secret:ELLIPTIC-5fL1JA"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_aggregator_tron_sqs_send_message_policys" {
  name        = "lambda-aggregator-tron-SQSSendMessage-policys"
  description = "Allows send message to SQS queue - Lookcard_Notification.fifo"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sqs:SendMessage"
        ],
        "Resource" : [
            "${var.sqs.lookcard_notification_queue_arn}"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "aggregator_tron_env_secrets_manager_read_attachments" {
  role       = aws_iam_role.lambda_aggregator_tron_roles.name
  policy_arn = aws_iam_policy.lambda_aggregator_tron_secrets_manager_read_policys.arn
}

resource "aws_iam_role_policy_attachment" "aggregator_tron_basic_executions" {
  role       = aws_iam_role.lambda_aggregator_tron_roles.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}

resource "aws_iam_role_policy_attachment" "aggregator_tron_execution_notifications" {
  role       = aws_iam_role.lambda_aggregator_tron_roles.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "aggregator_tron_sqs_send_message_attachments" {
  role       = aws_iam_role.lambda_aggregator_tron_roles.name
  policy_arn = aws_iam_policy.lambda_aggregator_tron_sqs_send_message_policys.arn
}
