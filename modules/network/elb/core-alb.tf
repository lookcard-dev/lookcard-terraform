data "aws_s3_bucket" "logs_bucket" {
  count  = 1
  bucket = "${var.aws_provider.account_id}-log"
}

resource "aws_lb" "core_application_load_balancer" {
  name               = "core-alb"
  internal           = true
  load_balancer_type = "application"
  subnets            = var.subnet_ids

  security_groups = [aws_security_group.core_application_load_balancer_security_group.id]

  enable_deletion_protection = var.runtime_environment == "production" ? true : false
  preserve_host_header       = true
  drop_invalid_header_fields = true

  access_logs {
    enabled = can(data.aws_s3_bucket.logs_bucket[0]) ? true : false
    bucket  = "${var.aws_provider.account_id}-log"
    prefix  = "ELB/core-application/access_logs"
  }
  connection_logs {
    enabled = can(data.aws_s3_bucket.logs_bucket[0]) ? true : false
    bucket  = "${var.aws_provider.account_id}-log"
    prefix  = "ELB/core-application/connection_logs"
  }
}

resource "aws_lb_listener" "core_application_load_balancer_http_listener" {
  load_balancer_arn = aws_lb.core_application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found - The requested URL was not found on this server."
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "core_http_healthcheck" {
  listener_arn = aws_lb_listener.core_application_load_balancer_http_listener.arn
  priority     = 1 # Highest priority

  action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "OK"
      status_code  = "200"
    }
  }

  condition {
    path_pattern {
      values = ["/healthcheckz"]
    }
  }
}
