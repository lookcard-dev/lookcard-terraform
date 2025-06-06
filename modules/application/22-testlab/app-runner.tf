resource "random_uuid" "next_auth_secret" {}

resource "aws_apprunner_custom_domain_association" "custom_domain" {
  domain_name = "lab.${var.domain.general.name}"
  service_arn = aws_apprunner_service.service.arn
}

resource "aws_apprunner_vpc_connector" "connector" {
  vpc_connector_name = "testlab-vpc-connector"
  subnets            = var.network.private_subnet_ids
  security_groups    = [aws_security_group.security_group.id]
}

resource "aws_apprunner_observability_configuration" "observability" {
  observability_configuration_name = "testlab-observability"
  trace_configuration {
    vendor = "AWSXRAY"
  }
}

resource "aws_apprunner_auto_scaling_configuration_version" "autoscaling" {
  auto_scaling_configuration_name = "testlab-autoscaling"
  max_size                        = 1
  min_size                        = 1
  tags = {
    Name = "testlab-autoscaling"
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
          ENVIRONMENT     = var.runtime_environment
          HOSTNAME        = "0.0.0.0"
          NEXTAUTH_SECRET = random_uuid.next_auth_secret.result
          NEXTAUTH_URL    = "https://lab.${var.domain.general.name}"
          REAP_API_URL    = "http://reap.proxy.lookcard.local:8080"
          PROFILE_API_URL = "http://profile.api.lookcard.local:8080"
          USER_API_URL    = "http://user.api.lookcard.local:8080"
          ACCOUNT_API_URL = "http://account.api.lookcard.local:8080"
          CARD_API_URL    = "http://card.api.lookcard.local:8080"
          CRYPTO_API_URL  = "http://crypto.api.lookcard.local:8080"
        }
        runtime_environment_secrets = {
          AZURE_AD_CLIENT_ID     = "${var.secret_arns["MICROSOFT"]}:AZURE_AD_CLIENT_ID::"
          AZURE_AD_CLIENT_SECRET = "${var.secret_arns["MICROSOFT"]}:AZURE_AD_CLIENT_SECRET::"
          AZURE_AD_TENANT_ID     = "${var.secret_arns["MICROSOFT"]}:AZURE_AD_TENANT_ID::"
        }
      }
      image_identifier      = "${var.repository_urls[var.name]}:${var.image_tag}"
      image_repository_type = "ECR"
    }
  }

  instance_configuration {
    cpu               = "256"
    memory            = "512"
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
