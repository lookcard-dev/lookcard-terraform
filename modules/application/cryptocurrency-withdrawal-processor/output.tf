output "crypto_fund_withdrawal_sg" {
  value = {
    id = aws_security_group.lambda_cryptocurrency_fund_withdrawal_sg.id
  }
}
