resource "aws_iam_role" "ecs_task_role" {
  name = "ecstaskrole"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sts:AssumeRole"
        ],
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    # Add tags if needed
  }
}

resource "aws_iam_role_policy_attachment" "ecs_role" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}




resource "aws_lb_listener_rule" "Authentication_listener_rule" {
  depends_on   = [var.vpc_id]
  listener_arn = var.aws_lb_listener_arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.authentication_tgp.arn
  }
  tags = {
    Name        = "Authentication-rule"
  }
  condition {
    path_pattern {
      values = ["/v2/api/auth-zqg2muwph/*"]
    }
  }
}

/////////////////////////////////////////////////////////////////

locals {
  secrets = [
    "ENV", "TOKEN", "DATABASE", "AML_ENV"
  ]
}

data "aws_secretsmanager_secret" "secrets" {
  for_each = toset(local.secrets)
  name = each.value
}

resource "aws_iam_policy" "secrets_manager_read_policy" {
  name        = "SecretsManagerReadOnlyPolicy"
  description = "Allows read-only access to Secrets Manager"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      for key, secret in data.aws_secretsmanager_secret.secrets : {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource" : secret.arn
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "secrets_manager_read_attachment" {
  name       = "SecretsManagerReadOnlyAttachment"
  roles      = [aws_iam_role.ecs_task_role.name]
  policy_arn = aws_iam_policy.secrets_manager_read_policy.arn
}

resource "aws_iam_policy" "Withdrawal_SQS_policy" {
  name        = "SQS_Access_Withdrawal"
  description = "Allows read-only access to Secrets Manager"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sqs:SendMessage"
        ],
        "Resource" : "${var.sqs_withdrawal}"
      }
    ]
  })
}
resource "aws_iam_policy_attachment" "Withdrawal__SQS_attachment" {
  name       = "SQSSendmessageAttachmentwithdrawal"
  roles      = [aws_iam_role.ecs_task_role.name]
  policy_arn = aws_iam_policy.Withdrawal_SQS_policy.arn
}
///////////////////////////////////////////////////////////////////


# *********************
resource "aws_lb_target_group" "authentication_tgp" {
  depends_on  = [var.network]
  name        = "Authentication"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.network.vpc

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
}

# *********************
resource "aws_ecs_service" "Authentication" {
  name            = "Authentication"
  task_definition = aws_ecs_task_definition.Authentication.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  cluster         = var.cluster
  network_configuration {
    subnets         = [var.network.private_subnet[0], var.network.private_subnet[1], var.network.private_subnet[2]] # Replace with your subnet IDs
    security_groups = [aws_security_group.Authentication.id]                                                   # Replace with your security group ID
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.authentication_tgp.arn
    container_name   = "Authentication"
    container_port   = "8000"
  }
}

# resource "aws_appautoscaling_policy" "Authentication" {
#   name               = "Authentication"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.Authentication.resource_id
#   scalable_dimension = aws_appautoscaling_target.Authentication.scalable_dimension
#   service_namespace  = aws_appautoscaling_target.Authentication.service_namespace
#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageCPUUtilization"
#     }
#     target_value       = 50 # Adjust this value as needed
#     scale_out_cooldown = 60
#     scale_in_cooldown  = 180
#   }

# }

# # Define autoscaling target
# resource "aws_appautoscaling_target" "Authentication" {
#   max_capacity       = 30 # Adjust this value as needed
#   min_capacity       = 6
#   resource_id        = "service/${var.cluster_name}/${aws_ecs_service.Authentication.name}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   service_namespace  = "ecs"

# }

#