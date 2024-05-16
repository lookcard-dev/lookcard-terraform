resource "aws_lambda_function" "eliptic" {
  function_name = "elliptic"
  role          = aws_iam_role.eliptic_role.arn
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  s3_bucket     = var.lambda_code.s3_bucket
  s3_key        = var.lambda_code.elliptic_s3key
  timeout       = 300

  vpc_config {
    subnet_ids         = var.network.private_subnet
    security_group_ids = [aws_security_group.eliptic_sg.id]
  }
}


resource "aws_security_group" "eliptic_sg" {
  name        = "eliptic-sg"
  description = "Security group for eliptic lambda"
  vpc_id      = var.network.vpc


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Eliptic-sg"
  }
}

resource "aws_iam_role" "eliptic_role" {
  name               = "eliptic_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_sts_policy.json
}


resource "aws_iam_role_policy_attachment" "eliptic_process_sqs_policy_attachment" {
  role       = aws_iam_role.eliptic_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}

resource "aws_iam_role_policy_attachment" "eliptic_vpc_policy_attachment" {
  role       = aws_iam_role.eliptic_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_policy" "eliptic_secrets_manager_read_policy" {
  name        = "SecretsManagerReadOnlyPolicyEliptic"
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
        "Resource" : "arn:aws:secretsmanager:ap-southeast-1:271609687710:secret:prod/lookcard/db-3U0Uzk"
      },
      {
        "Sid" : "Statement1",
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource" : "arn:aws:secretsmanager:ap-southeast-1:271609687710:secret:aml_env-R4SD1n"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "eliptic_secrets_manager_read_attachment" {
  name       = "SecretsManagerReadOnlyAttachment"
  roles      = [aws_iam_role.eliptic_role.name]
  policy_arn = aws_iam_policy.eliptic_secrets_manager_read_policy.arn
}


resource "aws_iam_policy" "eliptic_SQS_policy" {
  name        = "SQS_Access_Eliptic"
  description = "Allows read-only access to Secrets Manager"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:SendMessage",
          "sqs:GetQueueAttributes",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "*"
      }
    ]
  })
}
resource "aws_iam_policy_attachment" "eliptic_SQS_attachment" {
  name       = "SecretsManagerReadOnlyAttachment"
  roles      = [aws_iam_role.eliptic_role.name]
  policy_arn = aws_iam_policy.eliptic_SQS_policy.arn
}


