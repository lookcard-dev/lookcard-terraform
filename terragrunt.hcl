# Remote state configuration
remote_state {
  backend = "s3"
  config = {
    bucket         = "390844786071-lookcard-terraform"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "terraform"
    key            = "${path_relative_to_include()}/terraform.tfstate"
  }
}

# Generate provider configuration
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
locals {
  is_github_actions = sensitive(try(tobool(coalesce(var.github_actions, "false")), false))
}

provider "aws" {
  region     = local.aws_provider.application.region
  profile    = local.is_github_actions ? null : local.aws_provider.application.profile
  access_key = var.APPLICATION__AWS_ACCESS_KEY_ID
  secret_key = var.APPLICATION__AWS_SECRET_ACCESS_KEY
  token      = var.APPLICATION__AWS_SESSION_TOKEN

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}

provider "aws" {
  alias      = "us_east_1"
  region     = "us-east-1"
  profile    = local.is_github_actions ? null : local.aws_provider.application.profile
  access_key = var.APPLICATION__AWS_ACCESS_KEY_ID
  secret_key = var.APPLICATION__AWS_SECRET_ACCESS_KEY
  token      = var.APPLICATION__AWS_SESSION_TOKEN

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}

provider "aws" {
  alias      = "dns"
  region     = "us-east-1"
  profile    = local.is_github_actions ? null : local.aws_provider.dns.profile
  access_key = var.DNS__AWS_ACCESS_KEY_ID
  secret_key = var.DNS__AWS_SECRET_ACCESS_KEY
  token      = var.DNS__AWS_SESSION_TOKEN

  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}

provider "google-beta" {
  version = "~> 5.0"
}
EOF
}

# Generate required providers configuration
generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.dns, aws.us_east_1]
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0.0"
}
EOF
}

# Variables that will be available to all terragrunt.hcl files
inputs = {
  github_actions = get_env("GITHUB_ACTIONS", "false")
  
  # AWS credentials as environment variables
  APPLICATION__AWS_ACCESS_KEY_ID = get_env("APPLICATION__AWS_ACCESS_KEY_ID", "")
  APPLICATION__AWS_SECRET_ACCESS_KEY = get_env("APPLICATION__AWS_SECRET_ACCESS_KEY", "")
  APPLICATION__AWS_SESSION_TOKEN = get_env("APPLICATION__AWS_SESSION_TOKEN", "")
  
  DNS__AWS_ACCESS_KEY_ID = get_env("DNS__AWS_ACCESS_KEY_ID", "")
  DNS__AWS_SECRET_ACCESS_KEY = get_env("DNS__AWS_SECRET_ACCESS_KEY", "")
  DNS__AWS_SESSION_TOKEN = get_env("DNS__AWS_SESSION_TOKEN", "")
}
