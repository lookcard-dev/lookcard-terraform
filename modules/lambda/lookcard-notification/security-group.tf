resource "aws_security_group" "lookcard_notification_sg" {
  depends_on  = [var.network]
  name        = "lookcard-notification-security-group"
  description = "Security group for Lambda Lookcard Notification"
  vpc_id      = var.network.vpc

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}