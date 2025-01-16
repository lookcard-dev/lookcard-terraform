
resource "aws_security_group" "nat_security_group" {
  name_prefix = "nat-sg"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_eip" "nat_eip" {
  count                  = var.network.nat.provider == "instance" ? 0 : var.network.nat.count
  domain = "vpc"
  tags = {
    Name = "nat-eip-${count.index}"
  }
}

module "nat-instance" {
  source = "RaJiska/fck-nat/aws"
    count                  = var.network.nat.provider == "instance" ? 0 : var.network.nat.count
  name                 = "nat-instance-${count.index}"
  vpc_id               = aws_vpc.vpc.id
  subnet_id            = aws_subnet.public_subnet[count.index].id
  eip_allocation_ids   = ["eipalloc-abc1234"] # Allocation ID of an existing EIP
  use_cloudwatch_agent = true                 # Enables Cloudwatch agent and have metrics reported
  update_route_tables = true
  route_tables_ids = {
    "your-rtb-name-A" = "rtb-abc1234Foo"
    "your-rtb-name-B" = "rtb-abc1234Bar"
  }
  depends_on = [aws_security_group.nat_security_group, aws_eip.nat_eip]
}


# resource "aws_eip_association" "nat_eip_association" {
#   count                  = var.network.nat.provider == "instance" ? 0 : var.network.nat.count
#   instance_id   = element(nat_instance.*.id, count.index)
#   allocation_id = element(aws_eip.nat_eip.*.id, count.index)
#   depends_on = [nat_instance, aws_eip.nat_eip]
# }

resource "aws_nat_gateway" "nat_gateway" {
  count         =  var.network.nat.count
  allocation_id = element(aws_eip.nat_eip.*.id, 0)
  subnet_id   = element(aws_subnet.public_subnet.*.id, 0)
  depends_on = [aws_eip.nat_eip]
}
