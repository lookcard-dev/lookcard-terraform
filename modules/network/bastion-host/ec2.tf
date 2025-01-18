data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    # values = ["al2023-ami-*-arm64"]
    values = ["amzn2-ami-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "instance" {
  ami                     = data.aws_ami.amazon_linux_2023.id
  instance_type           = "t3a.nano"
  subnet_id               = var.subnet_ids[0]
  vpc_security_group_ids  = [aws_security_group.bastion_host_security_group.id]
  iam_instance_profile    = aws_iam_instance_profile.bastion_host_instance_profile.name
  disable_api_termination = true

  root_block_device {
    encrypted = true
  }

  #checkov:skip=CKV_AWS_135:t4g.nano have ebs_optimization enabled by default
  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-optimized.html
  monitoring = true
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  tags = {
    Name        = "Bastion Host"
    Environment = var.runtime_environment
    ManagedBy   = "Terraform"
  }
}
