resource "aws_security_group" "notification_dispatcher" {
  depends_on  = [var.network]
  name        = "notification-dispatcher-sg"
  description = "Security group for Lambda Notification Dispatcher"
  vpc_id      = var.network.vpc

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "lambda-lookcard-notification-sg"
  }
}
