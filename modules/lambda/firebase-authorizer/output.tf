output "lambda_firebase_authorizer_sg_id" {
  value = aws_security_group.lambda_firebase_authorizer_sg.id
}

output "firebase_authorizer_invoke_url" {
  value = aws_lambda_function.firebase_authorizer.invoke_arn
}