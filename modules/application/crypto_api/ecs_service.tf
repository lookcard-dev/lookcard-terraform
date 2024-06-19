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
        "Resource" : [
                "arn:aws:secretsmanager:ap-southeast-1:975050173595:secret:CryptoAPI-env-Q2vusb",
                "arn:aws:secretsmanager:ap-southeast-1:975050173595:secret:FIREBASE-fgDqIW",
                "arn:aws:secretsmanager:ap-southeast-1:975050173595:secret:uat/db/secret-8KkFTx"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "CryptoAPI_secrets_manager_read_attachment" {
  role      = aws_iam_role.crypto_api_task_execution_role.name
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
            "arn:aws:kms:ap-southeast-1:975050173595:key/5ee6de3f-009e-4e3f-9322-db20c30409b5",
            "arn:aws:kms:ap-southeast-1:975050173595:key/f71557ab-8443-4308-a825-c1ee6f111aa1"
        ]
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

  name            = "crypto_api"
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
    registry_arn   = aws_service_discovery_service.crypto_service.arn
  }
}

resource "aws_lb_target_group" "crypto_api_target_group" {
  name        = "crypto-api"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.network.vpc
}


resource "aws_lb_listener_rule" "crypto_api_listener_signer_rule" {
  listener_arn = var.default_listener

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.crypto_api_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/signer","/signers", "/signer/*"]
    }
  }

  priority = 10
  tags = {
    Name        = "crypto-api-signer-listener-rule"
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
    Name        = "crypto-api-blockchain-listener-rule"
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
    Name        = "crypto-api-hdwallet-listener-rule"
  }
}




