output "lambda_firebase_authorizer_sg_id" {
  value = aws_security_group.lambda_firebase_authorizer_sg.id
}

output "lambda_firebase_authorizer" {
  value = {
    invoke_arn = aws_lambda_function.firebase_authorizer.invoke_arn
    arn        = aws_lambda_function.firebase_authorizer.arn
  }
}
