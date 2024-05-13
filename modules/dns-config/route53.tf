data "aws_route53_zone" "application" {
  name = var.host_name
}

data "aws_route53_zone" "api" {
  name = var.api_host_name
}

resource "aws_route53_zone" "admin_panel" {
  name = var.admin_panel_host_name
}

resource "aws_route53_record" "admin_panel_record" {
  zone_id = var.admin_panel.id
  name    = ""
  type    = "A"
  alias {
    name                   = aws_alb.Admin_panel.dns_name
    zone_id                = aws_alb.Admin_panel.zone_id
    evaluate_target_health = true
  }
}
