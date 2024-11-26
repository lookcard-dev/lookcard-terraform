
resource "aws_iam_role" "lambda_cryptocurrency_fund_withdrawal_role" {
  name = "lambda-cryptocurrency-fund-withdrawal-role"
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

resource "aws_iam_policy" "lambda_cryptocurrency_fund_withdrawal_secrets_manager_read_policy" {
  name        = "lambda-cryptocurrency-fund-withdrawal-secretsReadOnlyPolicy"
  description = "Allows read-only access to Secret - SYSTEM_CRYPTO_WALLET and ELLIPTIC"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource" : local.secrets
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_cryptocurrency_fund_withdrawal_sqs_send_message_policy" {
  name        = "lambda-cryptocurrency-fund-withdrawal-SQSSendMessage-policy"
  description = "Allows send message to SQS queue - Crypto_Fund_Withdrawal.fifo"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sqs:SendMessage"
        ],
        "Resource" : local.sqs_queues
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "crypto_fund_withdrawal_env_secrets_manager_read_attachment" {
  role       = aws_iam_role.lambda_cryptocurrency_fund_withdrawal_role.name
  policy_arn = aws_iam_policy.lambda_cryptocurrency_fund_withdrawal_secrets_manager_read_policy.arn
}

resource "aws_iam_role_policy_attachment" "crypto_fund_withdrawal_sqs_send_message_attachment" {
  role       = aws_iam_role.lambda_cryptocurrency_fund_withdrawal_role.name
  policy_arn = aws_iam_policy.lambda_cryptocurrency_fund_withdrawal_sqs_send_message_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_cryptocurrency_fund_withdrawal_basic_execution" {
  role       = aws_iam_role.lambda_cryptocurrency_fund_withdrawal_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_cryptocurrency_fund_withdrawal_execution_notification" {
  role       = aws_iam_role.lambda_cryptocurrency_fund_withdrawal_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_cryptocurrency_fund_withdrawal_xraydaemon_write_policy" {
  role       = aws_iam_role.lambda_cryptocurrency_fund_withdrawal_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}
