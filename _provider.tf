terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "6.30.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }
}

locals {
  is_github_actions = sensitive(try(tobool(coalesce(var.github_actions, "false")), false))
}

variable "github_actions" {
  type    = string
  default = "false"
}

terraform {
  backend "s3" {
    bucket                      = "390844786071-lookcard-terraform"
    region                      = "ap-southeast-1"
    encrypt                     = true
    use_lockfile                = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
  }
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

provider "google-beta" {
  user_project_override = true
  project               = var.GCP_PROJECT_ID
}

provider "cloudflare" {
  api_token = var.CLOUDFLARE_API_TOKEN
}
