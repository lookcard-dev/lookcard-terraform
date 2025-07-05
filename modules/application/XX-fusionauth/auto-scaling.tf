resource "aws_appautoscaling_target" "ecs_target" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  depends_on = [
    aws_ecs_service.ecs_service
  ]
  max_capacity = 12
  min_capacity = var.runtime_environment == "production" ? 2 : 1
  resource_id        = "service/${var.cluster_id}/${var.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_cpu_policy" {
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  depends_on = [
    aws_appautoscaling_target.ecs_target
  ]
  name               = "${var.name}-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace

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
  count = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  depends_on = [
    aws_appautoscaling_target.ecs_target
  ]
  name               = "${var.name}-memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = 80.0 # Target Memory utilization (%)
    scale_in_cooldown  = 300  # 5 minutes
    scale_out_cooldown = 300  # 5 minutes
  }
}


# ALB Request Count Based Scaling for Kong (since it's the entry point)
resource "aws_appautoscaling_policy" "alb_request_count_policy" {
  count              = var.runtime_environment == "production" || var.runtime_environment == "staging" ? 1 : 0
  name               = "${var.name}-alb-request-count-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${var.elb.application_load_balancer_arn_suffix}/${aws_lb_target_group.service_target_group.arn_suffix}"
    }
    target_value       = 1000.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}