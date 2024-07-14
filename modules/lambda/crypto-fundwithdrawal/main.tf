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
      "CRYPTO_API_HOST"                 = "crypto.api.lookcard.local"
      "CRYPTO_API_PORT"                 = 8080
      "ACCOUNT_API_PROTOCOL"            = "http"
      "ACCOUNT_API_HOST"                = "account.api.lookcard.local"
      "ACCOUNT_API_PORT"                = 8080
      "ELLIPTIC_SECRET_ARN"             = "arn:aws:secretsmanager:ap-southeast-1:975050173595:secret:ELLIPTIC-5fL1JA"
      "SYSTEM_CRYPTO_WALLET_SECRET_ARN" = "arn:aws:secretsmanager:ap-southeast-1:975050173595:secret:SYSTEM_CRYPTO_WALLET-biOCGt"
      "SQS_NOTIFICATION_QUEUE_URL"      = var.sqs.lookcard_notification_queue_url
    }
  }

  vpc_config {
    subnet_ids         = var.network.private_subnet
    security_group_ids = [aws_security_group.crypto_fund_withdrawal_sg.id]
  }
}

resource "aws_lambda_event_source_mapping" "crypto_fund_withdrawal_queue_event" {
  depends_on                 = [aws_lambda_function.crypto_fund_withdrawal_function]
  event_source_arn           = var.sqs.crypto_fund_withdrawal_queue_arn
  function_name              = aws_lambda_function.crypto_fund_withdrawal_function.function_name
  batch_size                 = 10 # Change as per your requirements
}