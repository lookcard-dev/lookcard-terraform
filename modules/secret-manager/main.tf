resource "aws_secretsmanager_secret" "lookcard_secrets" {
  for_each    = toset(var.secret_names)
  name        = each.value
  description = "Secret for ${each.value}"

  lifecycle {
    prevent_destroy = true
  }
}
