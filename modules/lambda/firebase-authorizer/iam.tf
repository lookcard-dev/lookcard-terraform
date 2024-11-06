resource "aws_iam_role" "lambda_firebase_authorizer" {
  name = "lambda-firebase-authorizer-role"
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

resource "aws_iam_role_policy_attachment" "firebase_authorizer_execution_policy" {
  role       = aws_iam_role.lambda_firebase_authorizer.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# resource "aws_iam_policy" "lambda_firebase_authorizer_ecr_policy" {
#   name        = "lambda-aggregator-tron-ecr-policy"
#   description = "Allow get image"
#   policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Effect" : "Allow",
#         "Action" : [
#           "ecr:GetDownloadUrlForLayer",
#           "ecr:BatchGetImage",
#           "ecr:BatchCheckLayerAvailability"
#         ],
#         "Resource" : [
#           "*"
#         ]
#       },
#       {
#         "Effect" : "Allow",
#         "Action" : "ecr:GetAuthorizationToken",
#         "Resource" : "*"
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "lambda_firebase_authorizer_ecr_policy_attachments" {
#   role       = aws_iam_role.lambda_firebase_authorizer.name
#   policy_arn = aws_iam_policy.lambda_firebase_authorizer_ecr_policy.arn
# }
