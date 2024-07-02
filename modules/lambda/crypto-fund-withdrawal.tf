resource "aws_security_group" "Crypto_Fund_Withdrawal_SG" {
  depends_on  = [var.vpc_id]
  name        = "Lambda-Crypto-Fund-Withdrawal-Security-Group"
  description = "Security group for Lambda Crypto Fund Withdrawal"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Lambda-Crypto-Fund-Withdrawal-Security-Group"
  }
}


resource "aws_iam_role" "crypto_fund_withdrawal_role" {
  name = "Lambda-Crypto-Fund-Withdrawal-role"
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

resource "aws_iam_policy" "Lambda_Crypto_Fund_Withdrawal_secrets_manager_read_policy" {
  name        = "Lambda-Crypto-Fund-Withdrawal-SecretsReadOnlyPolicy"
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
        "Resource" : [
          "arn:aws:secretsmanager:ap-southeast-1:975050173595:secret:SYSTEM_CRYPTO_WALLET-biOCGt",
          "arn:aws:secretsmanager:ap-southeast-1:975050173595:secret:ELLIPTIC-5fL1JA"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "Lambda_Crypto_Fund_Withdrawal_sqs_send_message_policy" {
  name        = "Lambda-Crypto-Fund-Withdrawal-SQSSendMessage-policy"
  description = "Allows send message to SQS queue - Crypto_Fund_Withdrawal.fifo"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sqs:SendMessage"
        ],
        "Resource" : [
          "arn:aws:sqs:ap-southeast-1:975050173595:Crypto_Fund_Withdrawal.fifo"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "crypto_fund_withdrawal_env_secrets_manager_read_attachment" {
  role       = aws_iam_role.crypto_fund_withdrawal_role.name
  policy_arn = aws_iam_policy.Lambda_Crypto_Fund_Withdrawal_secrets_manager_read_policy.arn
}

resource "aws_iam_role_policy_attachment" "Lambda_crypto_fund_withdrawal_basic_execution" {
  role       = aws_iam_role.crypto_fund_withdrawal_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}

resource "aws_iam_role_policy_attachment" "Lambda_crypto_fund__execution_notification" {
  role       = aws_iam_role.crypto_fund_withdrawal_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "crypto_fund_withdrawal_sqs_send_message_attachment" {
  role       = aws_iam_role.crypto_fund_withdrawal_role.name
  policy_arn = aws_iam_policy.Lambda_Crypto_Fund_Withdrawal_sqs_send_message_policy.arn
}


data "aws_ecr_image" "crypto_fund_withdrawal" {
  repository_name = "crypto-fund-withdrawal"
  most_recent     = true
}

resource "aws_lambda_function" "crypto_fund_withdrawal_function" {
  function_name = "Crypto_Fund_Withdrawal"
  role          = aws_iam_role.crypto_fund_withdrawal_role.arn
  architectures = ["x86_64"]
  package_type  = "Image"
  image_uri     = data.aws_ecr_image.crypto_fund_withdrawal.image_uri
  timeout       = 900
  memory_size   = 512

  environment {
    variables = {
      "CRYPTO_API_PROTOCOL"             = "http"
      "CRYPTO_API_HOST"                 = "crypto.lookcard.local"
      "CRYPTO_API_PORT"                 = 8080
      "ACCOUNT_API_PROTOCOL"            = "http"
      "ACCOUNT_API_HOST"                = "account.lookcard.local"
      "ACCOUNT_API_PORT"                = 8080
      "ELLIPTIC_SECRET_ARN"             = "arn:aws:secretsmanager:ap-southeast-1:975050173595:secret:ELLIPTIC-5fL1JA"
      "SYSTEM_CRYPTO_WALLET_SECRET_ARN" = "arn:aws:secretsmanager:ap-southeast-1:975050173595:secret:SYSTEM_CRYPTO_WALLET-biOCGt"
      "SQS_NOTIFICATION_QUEUE_URL"      = aws_sqs_queue.Lookcard_Notification_Queue.url
    }
  }

  vpc_config {
    subnet_ids         = var.network.private_subnet
    security_group_ids = [aws_security_group.Crypto_Fund_Withdrawal_SG.id]
  }
}

