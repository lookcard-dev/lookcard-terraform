
resource "aws_security_group" "transaction_listener_sg" {
  depends_on  = [var.vpc_id]
  name        = "Transaction-Listener-Service-Security-Group"
  description = "Security group for Transaction Listener services"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Transaction-Listener-Security-Group"
  }
}
