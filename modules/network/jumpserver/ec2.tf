# data "aws_ssm_parameter" "ubuntu_22_04_lts" {
#   name = "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/ami-id"
# }

data "aws_ssm_parameter" "amazon_linux_2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

data "aws_subnet" "selected" {
  id = var.subnet_ids[0]
}

# Create an Elastic IP for the instance
resource "aws_eip" "jumpserver_eip" {
  domain = "vpc"
  
  tags = {
    Name        = "jumpserver-eip"
    Environment = var.runtime_environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_instance" "instance" {
  ami                    = data.aws_ssm_parameter.amazon_linux_2023.value
  instance_type          = "t3.large"
  subnet_id              = var.subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.jumpserver_security_group.id]
  source_dest_check      = false

  # Configure the root volume with proper settings to ensure persistence
  root_block_device {
    volume_type = "gp3"
    volume_size = 40
    encrypted   = true
    tags = {
      Name        = "jumpserver-root-volume"
      Environment = var.runtime_environment
      ManagedBy   = "Terraform"
    }
  }
  monitoring = true
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  tags = {
    Name        = "jumpserver"
    Environment = var.runtime_environment
    ManagedBy   = "Terraform"
  }
}

# Associate the Elastic IP with the instance
resource "aws_eip_association" "jumpserver_eip_assoc" {
  instance_id   = aws_instance.instance.id
  allocation_id = aws_eip.jumpserver_eip.id
}
