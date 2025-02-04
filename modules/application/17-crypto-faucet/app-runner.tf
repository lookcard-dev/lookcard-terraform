data "aws_ecr_repository" "repository" {
  name = var.name
}

resource "random_uuid" "next_auth_secret" {}

resource "aws_apprunner_custom_domain_association" "custom_domain" {
  domain_name = "faucet.lookcard.dev"
  service_arn = aws_apprunner_service.service.arn
}

resource "aws_apprunner_vpc_connector" "connector" {
  vpc_connector_name = "crypto-faucet-vpc-connector"
  subnets            = var.network.private_subnet_ids
  security_groups    = [aws_security_group.security_group.id]
}

resource "aws_apprunner_observability_configuration" "observability" {
  observability_configuration_name = "crypto-faucet-observability" 
  trace_configuration {
    vendor = "AWSXRAY"
  }
}

resource "aws_apprunner_auto_scaling_configuration_version" "autoscaling" {
  auto_scaling_configuration_name = "crypto-faucet-autoscaling"
  max_size        = 1
  min_size        = 1
  tags = {
    Name = "crypto-faucet-autoscaling"
  }
}

resource "aws_apprunner_service" "service" {
  service_name = var.name
  
  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.autoscaling.arn

  observability_configuration {
    observability_configuration_arn = aws_apprunner_observability_configuration.observability.arn
    observability_enabled           = true
  }

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.app_runner_role.arn
    }
    
    image_repository {
      image_configuration {
        port = "8080"
        runtime_environment_variables = {
          ENVIRONMENT = var.runtime_environment
          REDIS_URL = "rediss://${var.datacache.endpoint}:6379"
          HOSTNAME = "0.0.0.0"
          NEXTAUTH_SECRET = random_uuid.next_auth_secret.result
        }
        runtime_environment_secrets = {
            PRIVATE_KEY = "${data.aws_secretsmanager_secret.wallet.arn}:FAUCET::"
            AZURE_AD_CLIENT_ID = "${data.aws_secretsmanager_secret.microsoft.arn}:AZURE_AD_CLIENT_ID::" 
            AZURE_AD_CLIENT_SECRET = "${data.aws_secretsmanager_secret.microsoft.arn}:AZURE_AD_CLIENT_SECRET::"
            AZURE_AD_TENANT_ID = "${data.aws_secretsmanager_secret.microsoft.arn}:AZURE_AD_TENANT_ID::"
        }
      }
      image_identifier      = "${data.aws_ecr_repository.repository.repository_url}:${var.image_tag}"
      image_repository_type = "ECR"
    }
  }

  instance_configuration {
    cpu    = "256"
    memory = "512"
    instance_role_arn = aws_iam_role.instance_role.arn
  }

  network_configuration {
    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = aws_apprunner_vpc_connector.connector.arn
    }
  }


  tags = {
    Name        = var.name
    Environment = var.runtime_environment
  }
}
