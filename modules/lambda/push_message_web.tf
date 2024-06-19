data "aws_iam_policy_document" "push_web" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "push_web_role" {
  name               = "push_web_role"
  assume_role_policy = data.aws_iam_policy_document.push_web.json
}

resource "aws_iam_role_policy_attachment" "push_web_sqs_policy_attachment" {
  role       = aws_iam_role.push_web_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}


resource "aws_iam_role_policy_attachment" "push_web_api_policy_attachment" {
  role       = aws_iam_role.push_web_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayInvokeFullAccess"
}


resource "aws_iam_policy" "push_secrets_manager_read_policy" {
  name        = "SecretsManagerReadOnlyPolicyPushMeassageWeb"
  description = "Allows read-only access to Secrets Manager"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Statement1",
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

resource "aws_iam_policy_attachment" "push_web_secrets_manager_read_attachment" {
  name       = "SecretsManagerReadOnlyAttachment"
  roles      = [aws_iam_role.push_web_role.name]
  policy_arn = aws_iam_policy.push_secrets_manager_read_policy.arn
}




# resource "aws_iam_role_policy_attachment" "attach_dynamodb_policy_scan" {
#   role       = aws_iam_role.push_web_role.name
#   policy_arn = aws_iam_policy.dynamodb_policy_disconnect.arn
# }


resource "aws_lambda_function" "push_message_web_function" {
  depends_on    = [data.archive_file.lambda]
  function_name = "Push_Message_web"
  role          = aws_iam_role.push_web_role.arn
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  architectures = ["x86_64"]
  s3_bucket     = "lookcard-lambda-aml-code-testing"
  s3_key        = "lookcard-websocket.zip"
  timeout       = 300
}

