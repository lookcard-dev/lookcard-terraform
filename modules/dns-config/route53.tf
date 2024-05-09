data "aws_route53_zone" "application" {
  name = var.host_name
}

data "aws_route53_zone" "api" {
  name = var.api_host_name
}

resource "aws_route53_zone" "admin_panel" {
  name = var.admin_panel_host_name
}
