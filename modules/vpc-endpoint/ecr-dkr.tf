resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = var.network.vpc
  service_name      = "com.amazonaws.ap-southeast-1.ecr.dkr"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.network.private_subnet[*]

  security_group_ids = [aws_security_group.vpc_endpoint.id]

  private_dns_enabled = true

  tags = {
    Name = "ecr-dkr-endpoint"
  }
}
