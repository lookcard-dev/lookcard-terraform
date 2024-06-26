data "aws_iam_policy_document" "push_notifi" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "Push_Notification_role" {
  name               = "Push_Notification_role"
  assume_role_policy = data.aws_iam_policy_document.push_notifi.json
}


resource "aws_iam_role_policy_attachment" "push_notifi_sqs_policy_attachment" {
  role       = aws_iam_role.Push_Notification_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}

resource "aws_iam_role_policy_attachment" "push_notifi_vpc_policy_attachment" {
  role       = aws_iam_role.Push_Notification_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}


resource "aws_iam_policy" "push_notification_secrets_manager_read_policy" {
  name        = "SecretsManagerReadOnlyPolicyPushNotification"
  description = "Allows read-only access to Secrets Manager"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource" : "arn:aws:secretsmanager:ap-southeast-1:975050173595:secret:aml_env-6xOQxJ"
      }
    ]
  })
}


resource "aws_iam_policy_attachment" "Push_Notification_manager_read_attachment" {
  name       = "SecretsManagerReadOnlyAttachment"
  roles      = [aws_iam_role.Push_Notification_role.name]
  policy_arn = aws_iam_policy.push_notification_secrets_manager_read_policy.arn
}

resource "aws_security_group" "Push_Notification" {
  name        = "Push_Notifi-Security-Group"
  description = "Security group for ECS services"
  vpc_id      = var.network.vpc


  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Push-Notification-sg"
  }
}

resource "aws_lambda_function" "push_notification_function" {
  depends_on    = [data.archive_file.lambda]
  function_name = "Push_Notification"
  role          = aws_iam_role.Push_Notification_role.arn
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  architectures = ["x86_64"]
  s3_bucket     = "lookcard-lambda-aml-code-testing"
  s3_key        = "lookcard-pushnoification.zip"
  timeout       = 300
  # source_code_hash = data.archive_file.lambda.output_base64sha256
  vpc_config {
    subnet_ids         = var.network.private_subnet
    security_group_ids = [aws_security_group.Push_Notification.id]
  }
}
