resource "aws_api_gateway_account" "account_settings" {
  cloudwatch_role_arn = aws_iam_role.api_gateway_cloudwatch_role.arn
}

resource "aws_api_gateway_vpc_link" "nlb_vpc_link" {
  name        = "nlb-vpc-link"
  target_arns = [var.application.nlb.arn]

  tags = {
    Name = "nlb-vpc-link"
  }
}