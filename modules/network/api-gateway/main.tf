resource "aws_api_gateway_vpc_link" "vpc_link" {
  name        = "vpc-link"
  target_arns = [var.network_load_balancer_arn]
  lifecycle {
    create_before_destroy = true
  }
}
