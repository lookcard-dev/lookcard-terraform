output "edns_api_sg_id" {
  value = aws_security_group.edns_api_sg.id
}

output "edns_api_ecs_svc_sg" {
  value = {
    id = aws_security_group.edns_api_ecs_svc_sg.id
  }
}