# Create Network Load Balancer
resource "aws_lb" "nlb" {
  name               = "nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.network.private_subnet
}

# Create NLB Target Group
resource "aws_lb_target_group" "nlb_target" {
  name        = "nlb-target"
  port        = 80
  target_type = "alb"
  protocol    = "TCP"
  vpc_id      = var.network.vpc
}

resource "aws_lb_target_group_attachment" "nlb_tg_attachment" {
  target_group_arn = aws_lb_target_group.nlb_target.arn
  target_id        = aws_alb.look-card.arn
  port             = 80
}

# Create NLB Listener
resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_target.arn
  }
}


# resource "aws_alb" "admin_panel" {
#   name               = "admin-panel"
#   internal           = true
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.admin_panel_alb_sg.id]
#   subnets            = var.network.private_subnet_ids

#   enable_deletion_protection = true
#   preserve_host_header       = true
#   drop_invalid_header_fields = true

#   tags = {
#     Name = "Admin_Panel_ALB"
#   }

#   access_logs {
#     bucket  = var.alb_logging_bucket
#     enabled = true
#   }
# }
# resource "aws_route53_record" "admin_panel_record" {
#   depends_on = [aws_alb.admin_panel]
#   zone_id    = data.aws_route53_zone.hosted_zone_id.zone_id
#   name       = var.dns_config.admin_hostname
#   type       = "A"
#   alias {
#     name                   = aws_alb.admin_panel.dns_name
#     zone_id                = aws_alb.admin_panel.zone_id
#     evaluate_target_health = true
#   }
# }

# resource "aws_security_group" "admin_panel_alb_sg" {
#   name        = "admin-panel-alb-sg"
#   description = "Security group for admin panel alb"
#   vpc_id      = var.network.vpc

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "admin-panel-alb-sg"
#   }
# }


# resource "aws_wafv2_web_acl_association" "admin_web_acl_association" {
#   resource_arn = aws_alb.Admin_panel.arn
#   web_acl_arn  = var.admin_alb_waf
# }
#  ******************************************************
resource "aws_alb" "look-card" {
  name               = "look-card"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.api_alb_sg.id]
  subnets            = var.network.private_subnet

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
# **********************************

# resource "aws_lb_target_group" "lookcard_tg" {
  
#   name        = "Authentication"
#   port        = 80
#   protocol    = "HTTP"
#   target_type = "ip"
#   vpc_id      = var.network.vpc

#   lifecycle {
#       create_before_destroy = true
#   }

# }


resource "aws_lb_listener" "look-card" {
  load_balancer_arn = aws_alb.look-card.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = module.authentication.authentication_tgp_arn
    # target_group_arn = aws_lb_target_group.lookcard_tgdsadsadsadsadsadsa.arn
  }
  # depends_on        = [var.ssl]
  # port            = 443
  # protocol        = "HTTPS"
  # ssl_policy      = "ELBSecurityPolicy-2016-08"
  # certificate_arn = var.ssl
}
# *****************************************

# resource "aws_wafv2_web_acl_association" "alb_web_acl_association" {
#   resource_arn = aws_alb.look-card.arn
#   web_acl_arn  = var.alb_waf
# }
