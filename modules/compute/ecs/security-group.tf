resource "aws_security_group" "ec2_cluster_security_group" {
  name        = "ecs-ec2-cluster-sg"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ECS EC2 Cluster Security Group"
  }
}