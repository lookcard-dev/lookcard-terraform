# IAM Role for Lambda
resource "aws_iam_role" "stepfunction_lambda_role" {
  name = "stepfunction_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy for Lambda
resource "aws_iam_role_policy" "stepfunction_lambda_policy" {
  name   = "stepfunction_lambda_policy"
  role   = aws_iam_role.stepfunction_lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect: "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}



# IAM Role for Step Function
resource "aws_iam_role" "step_function_role" {
  name = "step_function_role_candel"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect: "Allow",
        Principal = {
          Service = "states.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy for Step Function
resource "aws_iam_policy" "step_function_policy" {
  name   = "step_function_policy_candel"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect: "Allow",
        Action = [
          "lambda:InvokeFunction"
        ],
        Resource = aws_lambda_function.stepfunction_testing_candel.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_step_function_policy" {
  role       = aws_iam_role.step_function_role.name
  policy_arn = aws_iam_policy.step_function_policy.arn
}