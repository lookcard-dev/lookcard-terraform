data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/opt/index.js"
  output_path = "${path.module}/tmp/lambda_function_payload.zip"
}


resource "aws_lambda_function" "stepfunction_testing_candel" {
  filename         = data.archive_file.lambda.output_path
  function_name    = "stepfunction_testing_candel"
  role             = aws_iam_role.stepfunction_lambda_role.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  source_code_hash = data.archive_file.lambda.output_base64sha256
}































