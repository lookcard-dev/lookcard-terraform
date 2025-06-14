# Auto Scaling Configuration for Supabase Services

# GoTrue Auto Scaling
resource "aws_appautoscaling_target" "gotrue" {
  max_capacity       = var.runtime_environment == "production" ? 10 : 3
  min_capacity       = var.runtime_environment == "production" ? 2 : 1
  resource_id        = "service/${var.cluster_id}/supabase-gotrue"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [aws_ecs_service.gotrue]
}

resource "aws_appautoscaling_policy" "gotrue_cpu_up" {
  name               = "gotrue-cpu-scale-up"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.gotrue.resource_id
  scalable_dimension = aws_appautoscaling_target.gotrue.scalable_dimension
  service_namespace  = aws_appautoscaling_target.gotrue.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 70.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}

resource "aws_appautoscaling_policy" "gotrue_memory_up" {
  name               = "gotrue-memory-scale-up"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.gotrue.resource_id
  scalable_dimension = aws_appautoscaling_target.gotrue.scalable_dimension
  service_namespace  = aws_appautoscaling_target.gotrue.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = 80.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}

# PostgREST Auto Scaling
resource "aws_appautoscaling_target" "postgrest" {
  max_capacity       = var.runtime_environment == "production" ? 10 : 3
  min_capacity       = var.runtime_environment == "production" ? 2 : 1
  resource_id        = "service/${var.cluster_id}/supabase-postgrest"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [aws_ecs_service.postgrest]
}

resource "aws_appautoscaling_policy" "postgrest_cpu_up" {
  name               = "postgrest-cpu-scale-up"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.postgrest.resource_id
  scalable_dimension = aws_appautoscaling_target.postgrest.scalable_dimension
  service_namespace  = aws_appautoscaling_target.postgrest.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 70.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}

resource "aws_appautoscaling_policy" "postgrest_memory_up" {
  name               = "postgrest-memory-scale-up"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.postgrest.resource_id
  scalable_dimension = aws_appautoscaling_target.postgrest.scalable_dimension
  service_namespace  = aws_appautoscaling_target.postgrest.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = 80.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}

# Postgres Meta Auto Scaling
resource "aws_appautoscaling_target" "postgres_meta" {
  max_capacity       = var.runtime_environment == "production" ? 5 : 2
  min_capacity       = var.runtime_environment == "production" ? 2 : 1
  resource_id        = "service/${var.cluster_id}/supabase-postgres-meta"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [aws_ecs_service.postgres_meta]
}

resource "aws_appautoscaling_policy" "postgres_meta_cpu_up" {
  name               = "postgres-meta-cpu-scale-up"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.postgres_meta.resource_id
  scalable_dimension = aws_appautoscaling_target.postgres_meta.scalable_dimension
  service_namespace  = aws_appautoscaling_target.postgres_meta.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 70.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}

resource "aws_appautoscaling_policy" "postgres_meta_memory_up" {
  name               = "postgres-meta-memory-scale-up"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.postgres_meta.resource_id
  scalable_dimension = aws_appautoscaling_target.postgres_meta.scalable_dimension
  service_namespace  = aws_appautoscaling_target.postgres_meta.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = 80.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}

# Kong Auto Scaling
resource "aws_appautoscaling_target" "kong" {
  max_capacity       = var.runtime_environment == "production" ? 10 : 3
  min_capacity       = var.runtime_environment == "production" ? 2 : 1
  resource_id        = "service/${var.cluster_id}/supabase-kong"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [aws_ecs_service.kong]
}

resource "aws_appautoscaling_policy" "kong_cpu_up" {
  name               = "kong-cpu-scale-up"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.kong.resource_id
  scalable_dimension = aws_appautoscaling_target.kong.scalable_dimension
  service_namespace  = aws_appautoscaling_target.kong.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 70.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}

resource "aws_appautoscaling_policy" "kong_memory_up" {
  name               = "kong-memory-scale-up"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.kong.resource_id
  scalable_dimension = aws_appautoscaling_target.kong.scalable_dimension
  service_namespace  = aws_appautoscaling_target.kong.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = 80.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}

# ALB Request Count Based Scaling for Kong (since it's the entry point)
resource "aws_appautoscaling_policy" "kong_request_count_up" {
  name               = "kong-request-count-scale-up"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.kong.resource_id
  scalable_dimension = aws_appautoscaling_target.kong.scalable_dimension
  service_namespace  = aws_appautoscaling_target.kong.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${var.elb.application_load_balancer_arn_suffix}/${aws_lb_target_group.kong.arn_suffix}"
    }
    target_value       = 1000.0
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}