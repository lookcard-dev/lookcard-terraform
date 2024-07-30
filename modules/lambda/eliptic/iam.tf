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
        "Resource" :[ 
          var.secret_manager.crypto_api_secret_arn,
          var.secret_manager.firebase_secret_arn,
          var.secret_manager.database_secret_arn,
          var.secret_manager.elliptic_secret_arn
        ]
      },

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
