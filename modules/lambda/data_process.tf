resource "aws_lambda_function" "data_process" {
  function_name = "data_process"
  role          = aws_iam_role.data_process_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  s3_bucket     = var.lambda_code.s3_bucket
  s3_key        = var.lambda_code.data_process_s3key
  timeout       = 300
}


resource "aws_iam_role" "data_process_role" {
  name               = "data_process_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_sts_policy.json
}


resource "aws_iam_role_policy_attachment" "data_process_sqs_policy_attachment" {
  role       = aws_iam_role.data_process_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}

resource "aws_iam_role_policy_attachment" "data_process_vpc_policy_attachment" {
  role       = aws_iam_role.data_process_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_policy" "data_process_sqs_policy" {
  name        = "SQS_Access_Data_Process"
  description = "Lambda data-process policy"
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

resource "aws_iam_policy" "data_process_secrets_manager_read_policy" {
  name        = "SecretsManagerReadOnlyPolicyDataProcess"
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
        "Resource" : var.secret_arn_list
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "data_processsecrets_manager_read_attachment" {
  name       = "SecretsManagerReadOnlyAttachment"
  roles      = [aws_iam_role.data_process_role.name]
  policy_arn = aws_iam_policy.data_process_secrets_manager_read_policy.arn
}
