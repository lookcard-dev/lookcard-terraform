resource "aws_secretsmanager_secret" "lookcard_secrets" {
  for_each    = toset(var.secret_names)
  name        = each.value
  description = "Secret for ${each.value}"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_secretsmanager_secret_version" "env_secret_value" {
  secret_id = aws_secretsmanager_secret.lookcard_secrets["env"].id

  secret_string = jsonencode(var.env_secrets)

  depends_on = [aws_secretsmanager_secret.lookcard_secrets]
}
