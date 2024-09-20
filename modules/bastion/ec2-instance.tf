resource "aws_instance" "bastion" {
  ami           = "ami-0a6b545f62129c495" # Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type
  instance_type = "t3.nano"

  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.bastion_profile.name
  subnet_id              = var.network.private_subnet[0]

  tags = {
    Name = "bastion-host"
  }

  # User data script to update and install necessary packages
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y htop
              EOF
}