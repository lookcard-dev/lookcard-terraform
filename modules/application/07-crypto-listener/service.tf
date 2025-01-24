resource "aws_ecs_service" "tron_nile_trongrid_ecs_service" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 1 : 0
  name            = "tron-nile_trongrid"
  task_definition = aws_ecs_task_definition.tron_nile_trongrid_task_definition[0].arn
  desired_count = var.image_tag == "latest" ? 0 : 1
  cluster       = var.cluster_id
  capacity_provider_strategy {
    capacity_provider = "LISTENER_EC2_AMD64"
    weight            = 1
  }
}

resource "aws_ecs_service" "tron_nile_getblock_ecs_service" {
  count = var.runtime_environment == "develop" || var.runtime_environment == "testing" ? 1 : 0
  name            = "tron-nile_getblock"
  task_definition = aws_ecs_task_definition.tron_nile_getblock_task_definition[0].arn
  desired_count = var.image_tag == "latest" ? 0 : 1
  cluster       = var.cluster_id
  capacity_provider_strategy {
    capacity_provider = "LISTENER_EC2_AMD64"
    weight            = 1
  }
} 