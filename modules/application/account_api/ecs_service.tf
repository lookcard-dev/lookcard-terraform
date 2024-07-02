resource "aws_service_discovery_service" "account_service" {
  name = "account"

  dns_config {
    namespace_id = var.lookcardlocal_namespace_id

    dns_records {
      ttl  = 10
      type = "A"
    }
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

locals {
  secrets = [
    { name = "CRYPTO_API_ENV", description = "CryptoAPI-env" },
    { name = "FIREBASE", description = "FIREBASE" },
    { name = "DATABASE", description = "DATABASE" },
    { name = "ELLIPTIC", description = "ELLIPTIC" }
  ]
}

data "aws_secretsmanager_secret" "secrets" {
  for_each = { for s in local.secrets : s.name => s }

  name = each.value.name
}

resource "aws_ecs_service" "Account_API" {
  name            = "Account-API"
  task_definition = aws_ecs_task_definition.Account_API.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  cluster         = var.cluster

  network_configuration {
    subnets         = [var.network.private_subnet[0], var.network.private_subnet[1], var.network.private_subnet[2]]
    security_groups = [aws_security_group.Account-API-SG.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.Account_API_target_group.arn
    container_name   = "Account-API"
    container_port   = 8080
  }

  service_registries {
    registry_arn = aws_service_discovery_service.account_service.arn
  }
}




resource "aws_iam_role" "Account_API_Task_Execution_Role" {
  name = "Account-API-Task-Execution-Role"
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
}

resource "aws_iam_policy" "Account_API_env_secrets_manager_read_policy" {
  name        = "AccountAPISecretsReadOnlyPolicy"
  description = "Allows read-only access to Secret - CryptoAPI-env and FIREBASE"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        "Resource" : [for s in data.aws_secretsmanager_secret.secrets : s.arn]

      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "Account_API_ECSTaskExecutionRolePolicy_attachment" {
  role       = aws_iam_role.Account_API_Task_Execution_Role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "Account_API_secrets_manager_read_attachment" {
  role       = aws_iam_role.Account_API_Task_Execution_Role.name
  policy_arn = aws_iam_policy.Account_API_env_secrets_manager_read_policy.arn
}

resource "aws_iam_role" "Account_API_Task_Role" {
  name = "Account-API-Task-Role"
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
}

resource "aws_iam_policy" "Account_API_SQS_SendMessage" {
  name        = "AccountAPI-SQSSendMessage"
  description = "Allows send message to Lookcard_Notification.fifo SQS Queue"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sqs:SendMessage"
        ],
        "Resource" : [
          "arn:aws:sqs:ap-southeast-1:576293270682:Lookcard_Notification.fifo",
          "arn:aws:sqs:ap-southeast-1:576293270682:Crypto_Fund_Withdrawal.fifo"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "Account_API_SQS_SendMessage_attachment" {
  role       = aws_iam_role.Account_API_Task_Role.name
  policy_arn = aws_iam_policy.Account_API_SQS_SendMessage.arn
}




resource "aws_lb_target_group" "Account_API_target_group" {
  name        = "Account-API"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.network.vpc
  target_type = "ip"

  health_check {
    interval            = 30
    path                = "/healthcheckz"
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}

resource "aws_lb_listener_rule" "Account_API_listener_rule" {
  listener_arn = var.default_listener

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Account_API_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/accounts", "/account", "/account/*"]
    }
  }

  priority = 150
  tags = {
    Name = "Account-API-rule"
  }
}
