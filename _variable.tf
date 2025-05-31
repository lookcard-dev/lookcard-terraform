variable "aws_provider" {
  type = object({
    application = object({
      account_id = string
      region     = string
      profile    = string
    })
    dns = object({
      account_id = string
      region     = string
      profile    = string
    })
  })
}

variable "domain" {
  type = object({
    general = object({
      name    = string
      zone_id = string
    })
    admin = object({
      name    = string
      zone_id = string
    })
    developer = object({
      name    = string
      zone_id = string
    })
  })
  default = {
    general = {
      name    = "develop.not-lookcard.com"
      zone_id = "Z01111111111111111111"
    }
    admin = {
      name    = "develop.not-lookcard.com"
      zone_id = "Z01111111111111111111"
    }
    developer = {
      name    = "develop.not-lookcard.com"
      zone_id = "Z01111111111111111111"
    }
  }
}

variable "network" {
  type = object({
    cidr = object({
      vpc = string
      subnets = object({
        public   = list(string)
        private  = list(string)
        database = list(string)
        isolated = list(string)
      })
    })
    nat = object({
      provider = string
      count    = number
    })
  })
}

variable "runtime_environment" {
  type = string
  validation {
    condition     = contains(["develop", "testing", "staging", "production", "sandbox"], var.runtime_environment)
    error_message = "runtime_environment must be one of: develop, testing, staging, production, or sandbox"
  }
}

variable "image_tag" {
  type = map(string)
  default = {
    "card-api"           = "latest"
    "user-api"           = "latest"
    "profile-api"        = "latest"
    "config-api"         = "latest"
    "data-api"           = "latest"
    "verification-api"   = "latest"
    "authentication-api" = "latest"
    "account-api"        = "latest"
    "referral-api"       = "latest"
    "notification-api"   = "latest"
    "reseller-api"       = "latest"
    "domain-api"         = "latest"
    "enrollment-api"     = "latest"
    "register-api"       = "latest"
    "crypto-api"         = "latest"
    "crypto-listener"    = "latest"
    "crypto-processor"   = "latest"
    "crypto-faucet"      = "latest"
    "cronjob"            = "latest"
    "reap-proxy"         = "latest"
    "apigw-authorizer"   = "latest"
    "webhook-api"        = "latest"
    "approval-api"       = "latest"
  }
}

locals {
  aws_provider = {
    application = {
      region     = var.aws_provider.application.region
      account_id = var.aws_provider.application.account_id
      profile    = local.is_github_actions ? null : var.aws_provider.application.profile
    }
    dns = {
      region     = var.aws_provider.dns.region
      account_id = var.aws_provider.dns.account_id
      profile    = local.is_github_actions ? null : var.aws_provider.dns.profile
    }
  }
  components = {
    "card-api" = {
      name = "card-api"
      hostname = {
        internal = "card.api"
      }
      image_tag = var.image_tag["card-api"]
    }
    "notification-api" = {
      name = "notification-api"
      hostname = {
        internal = "notification.api"
      }
      image_tag = var.image_tag["notification-api"]
    }
    "user-api" = {
      name = "user-api"
      hostname = {
        internal = "user.api"
      }
      image_tag = var.image_tag["user-api"]
    }
    "account-api" = {
      name = "account-api"
      hostname = {
        internal = "account.api"
      }
      image_tag = var.image_tag["account-api"]
    }
    "crypto-listener" = {
      name = "crypto-listener"
      hostname = {
        internal = "crypto.listener"
      }
      image_tag = var.image_tag["crypto-listener"]
    }
    "crypto-api" = {
      name = "crypto-api"
      hostname = {
        internal = "crypto.api"
      }
      image_tag = var.image_tag["crypto-api"]
    }
    "crypto-processor" = {
      name = "crypto-processor"
      hostname = {
        internal = "crypto.processor"
      }
      image_tag = var.image_tag["crypto-processor"]
    }
    "crypto-faucet" = {
      name = "crypto-faucet"
      hostname = {
        internal = "crypto.faucet"
      }
      image_tag = var.image_tag["crypto-faucet"]
    }
    "profile-api" = {
      name = "profile-api"
      hostname = {
        internal = "profile.api"
      }
      image_tag = var.image_tag["profile-api"]
    }
    "config-api" = {
      name = "config-api"
      hostname = {
        internal = "config.api"
      }
      image_tag = var.image_tag["config-api"]
    }
    "data-api" = {
      name = "data-api"
      hostname = {
        internal = "data.api"
      }
      image_tag = var.image_tag["data-api"]
    }
    "referral-api" = {
      name = "referral-api"
      hostname = {
        internal = "referral.api"
      }
      image_tag = var.image_tag["referral-api"]
    }
    "authentication-api" = {
      name = "authentication-api"
      hostname = {
        internal = "authentication.api"
      }
      image_tag = var.image_tag["authentication-api"]
    }
    "verification-api" = {
      name = "verification-api"
      hostname = {
        internal = "verification.api"
      }
      image_tag = var.image_tag["verification-api"]
    }
    "reseller-api" = {
      name = "reseller-api"
      hostname = {
        internal = "reseller.api"
        public   = "api.reseller"
      }
      image_tag = var.image_tag["reseller-api"]
    }
    "apigw-authorizer" = {
      name = "apigw-authorizer"
      hostname = {
        internal = "apigw.authorizer"
      }
      image_tag = var.image_tag["apigw-authorizer"]
    }
    "sumsub-webhook" = {
      name = "sumsub-webhook"
      hostname = {
        internal = "sumsub.webhook"
      }
      image_tag = lookup(var.image_tag, "sumsub-webhook", "latest")
    }
    "reap-webhook" = {
      name = "reap-webhook"
      hostname = {
        internal = "reap.webhook"
      }
      image_tag = lookup(var.image_tag, "reap-webhook", "latest")
    }
    "reap-proxy" = {
      name = "reap-proxy"
      hostname = {
        internal = "reap.proxy"
      }
      image_tag = var.image_tag["reap-proxy"]
    }
    "domain-api" = {
      name = "domain-api"
      hostname = {
        internal = "domain.api"
      }
      image_tag = var.image_tag["domain-api"]
    }
    "reseller-api" = {
      name = "reseller-api"
      hostname = {
        internal = "reseller.api"
      }
      image_tag = var.image_tag["reseller-api"]
    }
    "app-api" = {
      name = "app-api"
      hostname = {
        internal = "app.api"
      }
      image_tag = var.image_tag["app-api"]
    }
    "enrollment-api" = {
      name = "enrollment-api"
      hostname = {
        internal = "enrollment.api"
      }
      image_tag = var.image_tag["enrollment-api"]
    }
    "register-api" = {
      name = "register-api"
      hostname = {
        internal = "register.api"
      }
      image_tag = var.image_tag["register-api"]
    }
    "firebase-webhook" = {
      name = "firebase-webhook"
      hostname = {
        internal = "firebase.webhook"
      }
      image_tag = var.image_tag["firebase-webhook"]
    }
    "cronjob" = {
      name = "cronjob"
      hostname = {
        internal = "cronjob"
      }
      image_tag = var.image_tag["cronjob"]
    }
    "marketing-api" = {
      name = "marketing-api"
      hostname = {
        internal = "marketing.api"
      }
      image_tag = var.image_tag["marketing-api"]
    }
    "webhook-api" = {
      name = "webhook-api"
      hostname = {
        internal = "webhook.api"
      }
      image_tag = var.image_tag["webhook-api"]
    }
    "approval-api" = {
      name = "approval-api"
      hostname = {
        internal = "approval.api"
      }
      image_tag = var.image_tag["approval-api"]
    }
  }
}

// AWS Credentials
variable "APPLICATION__AWS_ACCESS_KEY_ID" {
  type      = string
  nullable  = true
  sensitive = true
  default   = null
}

variable "APPLICATION__AWS_SECRET_ACCESS_KEY" {
  type      = string
  nullable  = true
  sensitive = true
  default   = null
}

variable "APPLICATION__AWS_SESSION_TOKEN" {
  type      = string
  nullable  = true
  sensitive = true
  default   = null
}

variable "DNS__AWS_ACCESS_KEY_ID" {
  type      = string
  nullable  = true
  sensitive = true
  default   = null
}

variable "DNS__AWS_SECRET_ACCESS_KEY" {
  type      = string
  nullable  = true
  sensitive = true
  default   = null
}

variable "DNS__AWS_SESSION_TOKEN" {
  type      = string
  nullable  = true
  sensitive = true
  default   = null
}

variable "GCP_PROJECT_ID" {
  type      = string
  nullable  = true
  sensitive = true
  default   = null
}

variable "CLOUDFLARE_API_TOKEN" {
  type        = string
  description = "Cloudflare API token for authentication"
  default     = null
  sensitive   = true
}