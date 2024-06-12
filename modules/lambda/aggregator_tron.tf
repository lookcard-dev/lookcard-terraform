resource "aws_security_group" "Lambda_Aggregator_Tron_SG" {
  depends_on  = [var.vpc_id]
  name        = "Lambda_Aggregator-Tron-Security-Group"
  description = "Security group for Lambda Aggregator Tron"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Lambda_Aggregator-Tron-Security-Group"
  }
}





resource "aws_iam_role" "lambda_aggregator_tron_role" {
  name = "Lambda-Aggregator-Tron-role"
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

resource "aws_iam_policy" "Lambda_Aggregator_Tron_secrets_manager_read_policy" {
  name        = "Lambda-Aggregator-Tron-SecretsReadOnlyPolicy"
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

resource "aws_iam_policy" "Lambda_Aggregator_Tron_sqs_send_message_policy" {
  name        = "Lambda-Aggregator-Tron-SQSSendMessage-policy"
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
                "arn:aws:sqs:ap-southeast-1:975050173595:Lookcard_Notification.fifo"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "Aggregator_Tron_env_secrets_manager_read_attachment" {
  role       = aws_iam_role.lambda_aggregator_tron_role.name
  policy_arn = aws_iam_policy.Lambda_Aggregator_Tron_secrets_manager_read_policy.arn
}

resource "aws_iam_role_policy_attachment" "aggregator_tron_basic_execution" {
  role       = aws_iam_role.lambda_aggregator_tron_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}

resource "aws_iam_role_policy_attachment" "aggregator_tron_execution_notification" {
  role       = aws_iam_role.lambda_aggregator_tron_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "Aggregator_Tron_sqs_send_message_attachment" {
  role       = aws_iam_role.lambda_aggregator_tron_role.name
  policy_arn = aws_iam_policy.Lambda_Aggregator_Tron_sqs_send_message_policy.arn
}





















data "aws_ecr_image" "aggregator_tron" {
  repository_name = "aggregator-tron"
  most_recent     = true
}

resource "aws_lambda_function" "aggregator_tron_function" {
  function_name = "Aggregator_Tron"
  role          = aws_iam_role.lambda_aggregator_tron_role.arn // Secret manager - Aggregator-env
  architectures = ["x86_64"]
  package_type  = "Image"
  image_uri     = data.aws_ecr_image.aggregator_tron.image_uri
  timeout       = 900
  memory_size   = 512 

  environment {
    variables = {
        "CRYPTO_API_PROTOCOL" = "http"
        "CRYPTO_API_HOST" = "crypto.lookcard.local"
        "CRYPTO_API_PORT" = 8080
        "USER_API_PROTOCOL" = "http"
        "USER_API_HOST" = "_user.lookcard.local"
        "USER_API_PORT" = 8000
        "ACCOUNT_API_PROTOCOL" = "http"
        "ACCOUNT_API_HOST" = "account.lookcard.local"
        "ACCOUNT_API_PORT" = 8080
        "SECRET_MANAGER_NAME" = "Aggregator-env"
        "COINRANKING_SECRET_ARN" = "arn:aws:secretsmanager:ap-southeast-1:975050173595:secret:COINRANKING-5Js8eX"
        "ELLIPTIC_SECRET_ARN" = "arn:aws:secretsmanager:ap-southeast-1:975050173595:secret:ELLIPTIC-5fL1JA"
        "SYSTEM_CRYPTO_WALLET_SECRET_ARN" ="arn:aws:secretsmanager:ap-southeast-1:975050173595:secret:SYSTEM_CRYPTO_WALLET-biOCGt"
        "SQS_NOTIFICATION_QUEUE_URL" = aws_sqs_queue.Lookcard_Notification_Queue.url
    }
  }

  vpc_config {
    subnet_ids         = var.network.private_subnet
    security_group_ids = [aws_security_group.Lambda_Aggregator_Tron_SG.id]
  }
}