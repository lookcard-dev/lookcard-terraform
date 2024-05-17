data "aws_route53_zone" "hosted_zone_id" {
  name = var.domain
}

resource "aws_alb" "admin_panel" {
  name               = "admin-panel"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.admin_panel_alb_sg.id]
  subnets            = var.network.public_subnet_ids
  # subnets            = [var.subnet-pub-1[0], var.subnet-pub-2[1], var.subnet-pub-3[2]]

  enable_deletion_protection = true
  preserve_host_header       = true
  drop_invalid_header_fields = true

  tags = {
    Name = "Admin_Panel_ALB"
  }

  access_logs {
    bucket  = var.alb_logging_bucket
    enabled = true
  }
}

resource "aws_alb" "look-card" {
  name               = "look-card"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.api_alb_sg.id]
  subnets            = var.network.public_subnet_ids

  enable_deletion_protection = true
  preserve_host_header       = true
  drop_invalid_header_fields = true

  tags = {
    Name = "look-card-ALB"
  }

  access_logs {
    bucket  = var.alb_logging_bucket
    enabled = true
  }
}


resource "aws_route53_record" "admin_panel_record" {
  depends_on = [aws_alb.admin_panel]
  zone_id    = data.aws_route53_zone.hosted_zone_id.zone_id
  name       = var.dns_config.admin_hostname
  type       = "A"
  alias {
    name                   = aws_alb.admin_panel.dns_name
    zone_id                = aws_alb.admin_panel.zone_id
    evaluate_target_health = true
  }
}


# resource "aws_wafv2_web_acl_association" "admin_web_acl_association" {
#   resource_arn = aws_alb.Admin_panel.arn
#   web_acl_arn  = var.admin_alb_waf
# }


resource "aws_route53_record" "route53_record" {
  depends_on = [aws_alb.look-card]
  zone_id    = data.aws_route53_zone.hosted_zone_id.zone_id
  name       = var.dns_config.api_hostname
  type       = "A"
  alias {
    name                   = aws_alb.look-card.dns_name
    zone_id                = aws_alb.look-card.zone_id
    evaluate_target_health = true
  }
}


# resource "aws_wafv2_web_acl_association" "alb_web_acl_association" {
#   resource_arn = aws_alb.look-card.arn
#   web_acl_arn  = var.alb_waf
# }


resource "aws_security_group" "api_alb_sg" {
  name        = "look-card-alb-sg"
  description = "Security group for api alb "
  vpc_id      = var.network.vpc

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "look-card-ALB-SG"
  }
}

resource "aws_security_group" "admin_panel_alb_sg" {
  name        = "admin-panel-alb-sg"
  description = "Security group for admin panel alb"
  vpc_id      = var.network.vpc

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "admin-panel-alb-sg"
  }
}
