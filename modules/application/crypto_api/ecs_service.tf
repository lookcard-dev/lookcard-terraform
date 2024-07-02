resource "aws_iam_role" "crypto_api_task_execution_role" {
  name = "crypto_api_task_execution_role"
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

resource "aws_iam_role_policy_attachment" "Crypto_API_ECSTaskExecutionRolePolicy_attachment" {
  role       = aws_iam_role.crypto_api_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

locals {
  secrets = [
    { name = "CRYPTO_API_ENV", description = "CryptoAPI-env" },
    { name = "FIREBASE", description = "FIREBASE" },
    { name = "DATABASE", description = "DATABASE" },
  ]
}

data "aws_secretsmanager_secret" "secrets" {
  for_each = { for s in local.secrets : s.name => s }

  name = each.value.name
}

resource "aws_iam_policy" "crypto_api_env_secrets_manager_read_policy" {
  name        = "CryptoAPISecretsReadOnlyPolicy"
  description = "Allows read-only access to Secret - CryptoAPI-env"
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
        # "Resource" : [
        #         "arn:aws:secretsmanager:ap-southeast-1:576293270682:secret:crypto-api-env-a24Wh1",
        #         "arn:aws:secretsmanager:ap-southeast-1:576293270682:secret:firebase-JujygD",
        #         "arn:aws:secretsmanager:ap-southeast-1:576293270682:secret:db/secret-zkQPXo"
        # ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "CryptoAPI_secrets_manager_read_attachment" {
  role       = aws_iam_role.crypto_api_task_execution_role.name
  policy_arn = aws_iam_policy.crypto_api_env_secrets_manager_read_policy.arn
}

resource "aws_iam_role" "crypto_api_task_role" {
  name = "crypto-api-task-role"
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

  }
}

resource "aws_iam_policy" "CryptoAPI_KMS_GenerateDataKey_policy" {
  name        = "CryptoAPI_KMS_GenerateDataKey_policy"
  description = "Allows read-only access to Secret - CryptoAPI-env"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ],
        "Resource" : [
          "${var.crypto_api_encryption_kms_arn}",
          "${var.crypto_api_generator_kms_arn}"
        ]
        # "Resource" : [
        #     "arn:aws:kms:ap-southeast-1:576293270682:key/f83d712a-19fc-4932-9b98-9e40b7984f16",
        #     "arn:aws:kms:ap-southeast-1:576293270682:key/6a28f5b4-2996-486e-8d24-bbf3a44031d0"
        # ]
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "CryptoAPI_KMS_GenerateDataKey_attachment" {
  name       = "CryptoAPI_KMS_GenerateDataKey_policy"
  roles      = [aws_iam_role.crypto_api_task_role.name]
  policy_arn = aws_iam_policy.CryptoAPI_KMS_GenerateDataKey_policy.arn
}




resource "aws_service_discovery_service" "crypto_service" {
  name = "crypto"

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



resource "aws_ecs_service" "crypto_api" {
  name            = "crypto-api"
  task_definition = aws_ecs_task_definition.crypto-api.arn
  launch_type     = "FARGATE"
  desired_count   = 1
  cluster         = var.cluster

  network_configuration {
    subnets         = [var.network.private_subnet[0], var.network.private_subnet[1], var.network.private_subnet[2]]
    security_groups = [aws_security_group.crypto-api-sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.crypto_api_target_group.arn
    container_name   = "crypto-api"
    container_port   = 8080
  }

  service_registries {
    registry_arn = aws_service_discovery_service.crypto_service.arn
  }
}

resource "aws_lb_target_group" "crypto_api_target_group" {
  name        = "crypto-api"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.network.vpc
  health_check {
    interval            = 30
    path                = "/healthcheckz"
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}


resource "aws_lb_listener_rule" "crypto_api_listener_signer_rule" {
  listener_arn = var.default_listener

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.crypto_api_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/signer", "/signers", "/signer/*"]
    }
  }

  priority = 10
  tags = {
    Name = "crypto-api-signer-listener-rule"
  }
}

resource "aws_lb_listener_rule" "crypto_api_listener_blockchain_rule" {
  listener_arn = var.default_listener

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.crypto_api_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/blockchain", "/blockchain/*", "/blockchains"]
    }
  }

  priority = 101
  tags = {
    Name = "crypto-api-blockchain-listener-rule"
  }
}

resource "aws_lb_listener_rule" "crypto_api_listener_hdwallet_rule" {
  listener_arn = var.default_listener

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.crypto_api_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/hd-wallet"]
    }
  }

  priority = 100
  tags = {
    Name = "crypto-api-hdwallet-listener-rule"
  }
}




