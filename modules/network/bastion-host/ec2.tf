data "aws_ssm_parameter" "amazon_linux_2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-arm64"
}

resource "aws_instance" "instance" {
  lifecycle {
    ignore_changes = [ami]
  }
  ami                     = data.aws_ssm_parameter.amazon_linux_2023.value
  instance_type           = "t4g.nano"
  subnet_id               = var.subnet_ids[0]
  vpc_security_group_ids  = [aws_security_group.bastion_host_security_group.id]
  iam_instance_profile    = aws_iam_instance_profile.bastion_host_instance_profile.name
  disable_api_termination = true
  source_dest_check       = false

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
    Name        = "bastion-host"
    Environment = var.runtime_environment
    ManagedBy   = "Terraform"
  }
}
