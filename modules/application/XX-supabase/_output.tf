output "postgrest_security_group_id" {
  value = aws_security_group.postgrest_sg.id
}

output "postgres_meta_security_group_id" {
  value = aws_security_group.postgres_meta_sg.id
}

output "gotrue_security_group_id" {
  value = aws_security_group.gotrue_sg.id
}
