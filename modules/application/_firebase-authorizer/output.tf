output "lambda_firebase_authorizer_sg" {
  value = {
    id = aws_security_group.lambda_firebase_authorizer_sg.id
  }
}

output "lambda_firebase_authorizer" {
  value = {
    invoke_arn = aws_lambda_function.firebase_authorizer.invoke_arn
    arn        = aws_lambda_function.firebase_authorizer.arn
  }
}

output "firebase_authorizer_lambda_func_sg" {
  value = {
    id = aws_security_group.lambda_firebase_authorizer_sg.id
  }
}