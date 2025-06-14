resource "aws_apprunner_custom_domain_association" "studio_domain" {
  domain_name = "studio.supabase.${var.domain.admin.name}"
  service_arn = aws_apprunner_service.studio.arn
}

resource "aws_apprunner_vpc_connector" "studio_connector" {
  vpc_connector_name = "supabase-studio-vpc-connector"
  subnets            = var.network.private_subnet_ids
  security_groups    = [aws_security_group.studio_sg.id]
}

resource "aws_apprunner_observability_configuration" "studio_observability" {
  observability_configuration_name = "supabase-studio-observability"
  trace_configuration {
    vendor = "AWSXRAY"
  }
}

resource "aws_apprunner_auto_scaling_configuration_version" "studio_autoscaling" {
  auto_scaling_configuration_name = "supabase-studio-autoscaling"
  max_size                        = 3
  min_size                        = 1
  tags = {
    Name = "supabase-studio-autoscaling"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      tags
    ]
  }
}

resource "aws_apprunner_service" "studio" {
  service_name = "supabase-studio"

  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.studio_autoscaling.arn

  observability_configuration {
    observability_configuration_arn = aws_apprunner_observability_configuration.studio_observability.arn
    observability_enabled           = true
  }

  source_configuration {
    auto_deployments_enabled = false

    image_repository {
      image_identifier      = "public.ecr.aws/supabase/studio:2025.06.09-sha-4c1349f"
      image_repository_type = "ECR_PUBLIC"

      image_configuration {
        port = "3000"
        runtime_environment_variables = {
          # Studio Configuration - Using Cloud Map domains
          STUDIO_PG_META_URL        = "http://meta.supabase.lookcard.local:8080"
          SUPABASE_AUTH_URL         = "http://auth.supabase.lookcard.local:9999"
          SUPABASE_REST_URL         = "http://rest.supabase.lookcard.local:3000"
          SUPABASE_PUBLIC_URL       = "https://studio.supabase.${var.domain.admin.name}"
          SUPABASE_URL              = "https://studio.supabase.${var.domain.admin.name}"
          NEXT_PUBLIC_SUPABASE_URL  = "https://studio.supabase.${var.domain.admin.name}"
          POSTGRES_DB               = "supabase"
          HOSTNAME                  = "0.0.0.0"
          PORT                      = "3000"
          DEFAULT_ORGANIZATION_NAME = "LookCard"
          DEFAULT_PROJECT_NAME      = "LookCard"
        }
        runtime_environment_secrets = {
          # Database Connection - For Studio's database access
          POSTGRES_HOST     = "${var.secret_arns["DATABASE"]}:host::"
          POSTGRES_USER     = "${var.secret_arns["DATABASE"]}:username::"
          POSTGRES_PASSWORD = "${var.secret_arns["DATABASE"]}:password::"
          POSTGRES_PORT     = "${var.secret_arns["DATABASE"]}:port::"

          # Supabase Configuration
          SUPABASE_ANON_KEY             = "${var.secret_arns["SUPABASE"]}:anon_key::"
          SUPABASE_SERVICE_KEY          = "${var.secret_arns["SUPABASE"]}:service_role_key::"
          NEXT_PUBLIC_SUPABASE_ANON_KEY = "${var.secret_arns["SUPABASE"]}:anon_key::"
        }
      }
    }
  }

  # Health check configuration - Fixed based on GitHub issue #20655
  # Studio health check should use /api/profile endpoint with longer timeout
  # https://github.com/supabase/supabase/issues/20655
  health_check_configuration {
    healthy_threshold   = 1
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 20
    unhealthy_threshold = 5

  }

  instance_configuration {
    cpu               = "512"
    memory            = "1024"
    instance_role_arn = aws_iam_role.instance_role.arn
  }

  network_configuration {
    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = aws_apprunner_vpc_connector.studio_connector.arn
    }
  }

  tags = {
    Name        = "supabase-studio"
    Environment = var.runtime_environment
  }

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags to prevent unnecessary redeployments
      tags,
      # Ignore changes to auto-scaling config ARN if the actual config hasn't changed
      auto_scaling_configuration_arn
    ]
  }
}
