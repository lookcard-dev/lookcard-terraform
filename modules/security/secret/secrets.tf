resource "aws_secretsmanager_secret" "secret" {
  for_each    = toset(var.secrets)
  name        = each.value
  lifecycle {
    prevent_destroy = true
  }
}
