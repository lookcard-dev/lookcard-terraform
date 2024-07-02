resource "aws_security_group" "Lookcard_Notification_SG" {
  depends_on  = [var.vpc_id]
  name        = "Lookcard-Notification-Security-Group"
  description = "Security group for Lambda Lookcard Notification"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_iam_role" "lookcard_notification_role" {
  name = "Lookcard-Notification-role"
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

resource "aws_iam_policy" "lookcard_notification_secrets_manager_read_policy" {
  name        = "Loocard-Notification-SecretsReadOnlyPolicy"
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
          "arn:aws:secretsmanager:ap-southeast-1:975050173595:secret:notification-env-MwyOMr"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lookcard_notification_env_secrets_manager_read_attachment" {
  role       = aws_iam_role.lookcard_notification_role.name
  policy_arn = aws_iam_policy.lookcard_notification_secrets_manager_read_policy.arn
}

resource "aws_iam_role_policy_attachment" "Lambda_basic_execution_notification" {
  role       = aws_iam_role.lookcard_notification_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}
resource "aws_iam_role_policy_attachment" "Lambda_vpc_execution_notification" {
  role       = aws_iam_role.lookcard_notification_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

data "aws_ecr_image" "lookcard-notification" {
  repository_name = "lookcard-notification"
  most_recent     = true
}

resource "aws_lambda_function" "lookcard_notification_function" {
  function_name = "Lookcard_Notification"
  role          = aws_iam_role.lookcard_notification_role.arn
  architectures = ["x86_64"]
  package_type  = "Image"
  image_uri     = data.aws_ecr_image.lookcard-notification.image_uri
  timeout       = 900
  memory_size   = 512

  environment {
    variables = {
      "FROM_EMAIL"     = "no-reply@lookcard.io"
      "APP_NAME"       = "LOOKCARD"
      "AWS_SECRET_ARN" = "arn:aws:secretsmanager:ap-southeast-1:975050173595:secret:notification-env-MwyOMr"
    }
  }

  vpc_config {
    subnet_ids         = var.network.private_subnet
    security_group_ids = [aws_security_group.Lookcard_Notification_SG.id]
  }
}

