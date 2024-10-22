resource "aws_ecs_service" "tron_nile_listener_trongrid" {
  name            = local.nile-trongrid.name
  task_definition = aws_ecs_task_definition.tron_nile_listener_trongrid.arn
  capacity_provider_strategy {
    capacity_provider = var.capacity_provider_ec2_amd64_on_demand
    weight            = 1
  }
  desired_count = 1
  cluster       = var.cluster
}

resource "aws_ecs_service" "tron_nile_listener_getblock" {
  name            = local.nile-getblock.name
  task_definition = aws_ecs_task_definition.tron_nile_listener_getblock.arn
  capacity_provider_strategy {
    capacity_provider = var.capacity_provider_ec2_amd64_on_demand
    weight            = 1
  }
  desired_count = 1
  cluster       = var.cluster
}



