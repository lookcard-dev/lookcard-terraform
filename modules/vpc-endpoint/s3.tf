resource "aws_vpc_endpoint" "s3" {
  vpc_id       = var.network.vpc
  service_name = "com.amazonaws.ap-southeast-1.s3"
  route_table_ids = [var.rt_private_id]
#   route_table_ids = [aws_route_table.private.id]

  tags = {
    Name = "s3-endpoint"
  }
}









