resource "aws_iam_role" "lambda_sumbsub_webhook" {
  name = "lambda-sumsub-webhook-role"
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

resource "aws_iam_role_policy_attachment" "lambda_sumbsub_webhook" {
  role       = aws_iam_role.lambda_sumbsub_webhook.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "sumbsub_webhook_xraydaemon_write_policy" {
  role       = aws_iam_role.lambda_sumbsub_webhook.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}