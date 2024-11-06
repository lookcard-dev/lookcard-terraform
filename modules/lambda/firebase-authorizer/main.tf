data "aws_ecr_image" "apigw_authorizer" {
  repository_name = "apigw-authorizer"
  most_recent     = true
}

resource "aws_lambda_function" "firebase_authorizer" {
  depends_on = [ aws_iam_role.lambda_firebase_authorizer, aws_iam_role_policy_attachment.firebase_authorizer_execution_policy ]
  function_name = "Firebase_Authorizer"
  role          = aws_iam_role.lambda_firebase_authorizer.arn
  architectures = ["x86_64"]
  package_type  = "Image"
  image_uri     = data.aws_ecr_image.apigw_authorizer.image_uri # "${var.image.url}:${var.image.tag}"
  timeout       = 300
  memory_size   = 512
  handler       = "handlers/firebase.handler"

  vpc_config {
    subnet_ids         = var.network.private_subnet
    security_group_ids = [aws_security_group.lambda_firebase_authorizer_sg.id]
  }
}