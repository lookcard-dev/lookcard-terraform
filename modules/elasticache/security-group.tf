resource "aws_security_group" "redis_sg" {
  depends_on  = [var.network]
  name        = "Redis-Security-Group"
  description = "Security group for ElastiCacheRedis"
  vpc_id      = var.network.vpc

  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Redis-Security-Group"
  }
}
