resource "aws_appautoscaling_target" "ecs_target" {
  depends_on = [
    aws_ecs_service.ecs_service
  ]
  max_capacity = var.image_tag == "latest" ? 0 : (
    var.runtime_environment == "production" ? 12 : 1
  )
  min_capacity = var.image_tag == "latest" ? 0 : (
    var.runtime_environment == "production" ? 2 : 1
  )
  resource_id        = "service/${var.cluster_id}/${var.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_cpu_policy" {
  depends_on = [
    aws_appautoscaling_target.ecs_target
  ]
  name               = "${var.name}-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 80.0 # Target CPU utilization (%)
    scale_in_cooldown  = 300  # 5 minutes
    scale_out_cooldown = 300  # 5 minutes
  }
}

resource "aws_appautoscaling_policy" "ecs_memory_policy" {
  depends_on = [
    aws_appautoscaling_target.ecs_target
  ]
  name               = "${var.name}-memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = 80.0 # Target Memory utilization (%)
    scale_in_cooldown  = 300  # 5 minutes
    scale_out_cooldown = 300  # 5 minutes
  }
}