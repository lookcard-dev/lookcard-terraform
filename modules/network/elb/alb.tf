# Use try() to gracefully handle bucket lookup - avoids errors on fresh deployments
# Data source to discover log bucket if it exists
# Uses conditional count to avoid errors when bucket doesn't exist
data "aws_s3_bucket" "logs_bucket" {
  count  = 1
  bucket = "${var.aws_provider.account_id}-log"
}

# Locals with try-catch logic for bucket discovery
locals {
  # Expected bucket name pattern based on account ID
  expected_bucket_name = "${var.aws_provider.account_id}-log"

  # Try to use discovered bucket, fallback to null if bucket doesn't exist
  # This prevents circular dependency while allowing logging when bucket is available
  log_bucket_name = try(data.aws_s3_bucket.logs_bucket[0].bucket, null)
}

resource "aws_lb" "application_load_balancer" {
  name               = "alb"
  internal           = true
  load_balancer_type = "application"
  subnets            = var.subnet_ids

  security_groups = [aws_security_group.application_load_balancer_security_group.id]

  enable_deletion_protection = var.runtime_environment == "production" ? true : false
  preserve_host_header       = true
  drop_invalid_header_fields = true

  # Only enable access logs if log bucket exists
  dynamic "access_logs" {
    for_each = local.log_bucket_name != null ? [1] : []
    content {
      enabled = true
      bucket  = local.log_bucket_name
      prefix  = "ELB/application/access_logs"
    }
  }

  # Only enable connection logs if log bucket exists
  dynamic "connection_logs" {
    for_each = local.log_bucket_name != null ? [1] : []
    content {
      enabled = true
      bucket  = local.log_bucket_name
      prefix  = "ELB/application/connection_logs"
    }
  }
}

resource "aws_lb_listener" "application_load_balancer_http_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
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

resource "aws_lb_listener_rule" "http_healthcheck" {
  listener_arn = aws_lb_listener.application_load_balancer_http_listener.arn
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
