resource "aws_security_group" "ec2_cluster_security_group" {
  name        = "ecs-ec2-cluster-sg"
  vpc_id      = var.vpc_id

  tags = {
    Name = "ECS EC2 Cluster Security Group"
  }
}

resource "aws_vpc_security_group_egress_rule" "ec2_cluster_egress_rule" {
  security_group_id            = aws_security_group.ec2_cluster_security_group.id
  cidr_ipv4                    = "0.0.0.0/0"
  ip_protocol                  = "-1"
}